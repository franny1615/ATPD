//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import Combine
import CoreData
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
