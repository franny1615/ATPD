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
    
    @Published var previewUrl: URL?
    
    init(project: Project) {
        self.project = project
        
        self.bindImageChange()
    }
    
    private func bindImageChange() {
        $takenImage
            .sink { image in
                if let image = image {
                    self.project.phases[self.currentPhaseIndex].attachments.append(image)
                }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Phase Logic
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
    
    func previewImage(uiImage: UIImage) {
        let tempDirectory = FileManager.default.temporaryDirectory
        let path = tempDirectory.appendingPathComponent("Preview").appendingPathExtension(".jpg")
        
        do {
            let data = uiImage.jpegData(compressionQuality: 0.0)
            try data?.write(to: path, options: .atomic)
            self.previewUrl = path
        } catch {
            #if DEBUG
            let error = error as NSError
            print("❗️\(error.domain) : \(error.localizedDescription)")
            #endif
        }
    }
    
    // MARK: - Project Logic
    func saveProject() {
        
    }
    
    func deleteProject() {
        
    }
}
