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
    func saveProject() {
        // TODO: save to core data
    }
    
    func deleteProject() {
        // TODO: delete from core data
    }
}
