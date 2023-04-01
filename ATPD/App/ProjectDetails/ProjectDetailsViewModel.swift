//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import Combine
import CoreData
import SwiftUI

let phaseDescPlaceholder = "Description"

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
        self.project.addToPhases(newPhase)
        self.phases = (project.phases.allObjects as? [Phase]) ?? []
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
        guard !self.project.title.isEmpty else {
            self.error = NSError(domain: "Title Required",
                                 code: 200,
                                 userInfo: [NSLocalizedDescriptionKey: "A project must at minimum contain a populated title field."])
            self.showError = true
            
            return false
        }
        
        do {
            self.project.changedOn = Date()
            try context.save()
            
            return true
        } catch {
            self.error = error as NSError
            self.showError = true
            
            return false
        }
    }
    
    func deleteProject() {
        // TODO: delete from core data
    }
}
