//
//  ProjectViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import CoreData
import SwiftUI

class ProjectViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    @Published var projects: [Project]
    
    @Published var error: NSError?
    @Published var showError = false
    
    init(persistanceController: PersistenceController = .shared,
         projects: [Project] = []) {
        self.projects = projects
        self.context = persistanceController.container.viewContext
    }
    
    func fetchProjectsFromCoreData() {
        do {
            let fetchRequest = Project.fetchRequest() as NSFetchRequest<Project>
            self.projects = try context.fetch(fetchRequest)
        } catch {
            self.error = error as NSError
            self.showError = true
        }
    }
    
    func getProjectDetailsVM(for selectedProject: Project? = nil) -> ProjectDetailsViewModel {
        if let selectedProject = selectedProject {
            return ProjectDetailsViewModel(project: selectedProject)
        }
        
        
        let newProject = Project(context: context)
        newProject.createdOn = Date()
        return ProjectDetailsViewModel(project: newProject)
    }
}
