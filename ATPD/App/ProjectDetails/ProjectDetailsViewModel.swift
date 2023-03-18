//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import SwiftUI

class ProjectDetailsViewModel: ObservableObject {
    @Published var project: Project
    
    init(project: Project) {
        self.project = project
    }
}
