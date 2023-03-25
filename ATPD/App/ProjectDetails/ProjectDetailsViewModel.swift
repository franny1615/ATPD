//
//  ProjectDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import Combine
import SwiftUI

let phaseDescPlaceholder = "Description"

class ProjectDetailsViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    @Published var project: Project
    
    @Published var showCameraView = false
    @Published var takenImage: UIImage?
    private var currentPhaseIndex = 0
    
    init(project: Project) {
        self.project = project
        
        self.bindImageChange()
    }
    
    private func bindImageChange() {
        $takenImage
            .sink { image in
                if let image = image,
                   let base64 = image.jpegData(compressionQuality: 0.0)?.base64EncodedString() {
                    self.project.phases[self.currentPhaseIndex].attachments.append(base64)
                }
            }
            .store(in: &subscriptions)
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
    
    func takePictureForPhase(at index: Int) {
        currentPhaseIndex = index
        showCameraView = true
    }
}
