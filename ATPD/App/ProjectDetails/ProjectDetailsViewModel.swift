//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import SwiftUI

let phaseDescPlaceholder = "Description"

class ProjectDetailsViewModel: ObservableObject {
    @Published var project: Project
    
    init(project: Project) {
        self.project = project
    }
    
    func addPhase() {
        project.phases.append(Phase(isComplete: false,
                                    title: "",
                                    description: phaseDescPlaceholder,
                                    attachments: []))
    }
    
    func deletePhase(at index: Int) {
        project.phases.remove(at: index)
    }
}
