//
//  ProjectViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import CoreData
import SwiftUI

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project]
    
    @Published var error: NSError?
    @Published var showError = false
    
    init(projects: [Project]) {
        self.projects = projects
    }
    
    func fetchProjectsFromCoreData(filter: NSPredicate? = nil) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Projects")
        request.predicate = filter
        
        do {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                projects = []
                let context = appDelegate.persistentContainer.viewContext
                let result = try context.fetch(request)
                
                for possibleProject in result as! [NSManagedObject] {
                    projects.append(try Project.deserialize(from: possibleProject))
                }
            }
        } catch {
            self.error = error as NSError
            self.showError = true
        }
    }
    
    func getProjectDetailsVM(for selectedProject: Project? = nil) -> ProjectDetailsViewModel {
        if let selectedProject = selectedProject {
            return .init(project: selectedProject)
        }
        
        return .init(project: .init(title: "",
                                    body: "",
                                    attachments: NSData(),
                                    createdOn: Date(),
                                    changedOn: Date(),
                                    createdBy: ""))
    }
}
