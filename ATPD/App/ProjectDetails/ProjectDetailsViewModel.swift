//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import Combine
import CoreData
import PDFKit
import SwiftUI

class ProjectDetailsViewModel: ObservableObject {
    private var context: NSManagedObjectContext
    @Published var project: Project
    @Published var phases: [Phase]
    
    @Published var error: NSError?
    @Published var showError = false

    init(persistanceController: PersistenceController = .shared,
         project: Project) {
        self.context = persistanceController.container.viewContext
        self.project = project
        self.phases = (project.phases.allObjects as? [Phase]) ?? []
    }
    
    // MARK: - Phase Logic
    func addPhase() {
        let newPhase = Phase(context: context)
        newPhase.addedOn = Date()
        self.project.addToPhases(newPhase)
        self.phases = (project.phases.allObjects as? [Phase]) ?? []
        self.phases.sort(by: { $0.addedOn < $1.addedOn })
    }
    
    func deletePhase(_ phase: Phase) {
        self.project.removeFromPhases(phase)
        self.phases = (project.phases.allObjects as? [Phase]) ?? []
    }
    
    func getPhaseDetailsViewModel(for phase: Phase) -> PhaseDetailsViewModel {
        let phaseDetailsVM = PhaseDetailsViewModel(phase: phase)
        phaseDetailsVM.deletePhase = {
            self.deletePhase(phase)
        }
        
        return phaseDetailsVM
    }
    
    // MARK: - Project Logic
    func saveProject() -> Bool {
        guard !self.project.title.isEmpty && !self.project.createdBy.isEmpty else {
            self.error = NSError(domain: "Title, Name Required",
                                 code: 200,
                                 userInfo: [NSLocalizedDescriptionKey: "A project must contain a title and who is making the project."])
            self.showError = true
            
            return false
        }
        
        self.project.changedOn = Date()
        return self.saveToCoreData()
    }
    
    func deleteProject() -> Bool {
        self.context.delete(self.project)
        return self.saveToCoreData()
    }
    
    func deleteProjectIfEmpty() -> Bool {
        if project.title.isEmpty && project.createdBy.isEmpty {
            self.context.delete(project)
            return true
        } else {
            return self.saveProject()
        }
    }
    
    // MARK: - Project to JSON
    func convertProjectToJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.project)
            let jsonString = String(data: data, encoding: .utf8)
            return jsonString
        } catch {
            self.error = error as NSError
            self.showError = true
            return nil
        }
    }
    
    func save(_ jsonString: String) -> URL? {
        do {
            let path = FileManager.default.temporaryDirectory
            let savePath = path.appendingPathComponent("ProjectAsJSON").appendingPathExtension(".json")
            let data = jsonString.data(using: .utf8)
            
            try data?.write(to: savePath, options: .atomic)
            return savePath
        } catch {
            self.error = error as NSError
            self.showError = true
            return nil
        }
    }
    
    // MARK: - Project to PDF
    func generatePDF() -> Data? {
        let pdfMetaData: [String: Any] = [
            String(kCGPDFContextCreator): "ATDP - Alpha Technologies",
            String(kCGPDFContextAuthor): self.project.createdBy,
            String(kCGPDFContextTitle): self.project.title
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData
        
        let pageRect = CGRect(x: 10, y: 10, width: 595.2, height: 841.8) // A4 page size
        let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = graphicsRenderer.pdfData { (context) in
            context.beginPage()
            let defaultIndent: CGFloat = 24.0
            let initialCursor: CGFloat = 32
            
            var cursor = context.addCenterText(text: self.project.title, cursor: initialCursor, pdfSize: pageRect.size)
            cursor = context.addCenterText(fontSize: 15.0, text: "by \(self.project.createdBy)", cursor: cursor, pdfSize: pageRect.size)
            
            cursor += 42 // some white space
            cursor = context.addSingleLineText(weight: .medium,
                                               text: "Description",
                                               indent: defaultIndent,
                                               cursor: cursor,
                                               pdfSize: pageRect.size)
            cursor = context.addMultiLineText(text: self.project.body,
                                              indent: defaultIndent + 8.0,
                                              cursor: cursor,
                                              pdfSize: pageRect.size)
            
            cursor += 16.0 // more white space
            cursor = context.addSingleLineText(weight: .medium,
                                               text: "Phases",
                                               indent: defaultIndent,
                                               cursor: cursor,
                                               pdfSize: pageRect.size)
            for phase in phases {
                cursor = context.addSingleLineText(text: phase.title,
                                                   indent: defaultIndent + 8.0,
                                                   cursor: cursor,
                                                   pdfSize: pageRect.size)
                cursor = context.addMultiLineText(text: phase.phaseDescription,
                                                  indent: defaultIndent + 8.0,
                                                  cursor: cursor,
                                                  pdfSize: pageRect.size)
                cursor = context.addSingleLineText(weight: .bold,
                                                   text: "Has \(phase.isComplete ? "been completed.": " NOT been completed.")",
                                                   indent: defaultIndent + 8.0,
                                                   cursor: cursor,
                                                   pdfSize: pageRect.size)
                cursor += 8.0
            }
        }
        
        return data
    }
    
    func savePDF(_ data: Data) -> URL? {
        do {
            let path = FileManager.default.temporaryDirectory
            let savePath = path.appendingPathComponent("ProjectAsPDF").appendingPathExtension(".pdf")
            try data.write(to: savePath, options: .atomic)
            
            return savePath
        } catch {
            self.error = error as NSError
            self.showError = true
            return nil
        }
    }
    
    // MARK: - Save to CoreData
    private func saveToCoreData() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            self.error = error as NSError
            self.showError = true
            return false
        }
    }
}
