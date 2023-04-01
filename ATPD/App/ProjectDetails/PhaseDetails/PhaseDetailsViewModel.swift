//
//  PhaseDetailsViewModel.swift
//  ATPD
//
//  Created by Francisco F on 3/26/23.
//

import Combine
import CoreData
import Foundation
import SwiftUI

class PhaseDetailsViewModel: ObservableObject {
    private let context: NSManagedObjectContext
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var phase: Phase
    @Published var showCameraView = false
    
    @Published var takenImage: UIImage?
    @Published var previewUrl: URL?
    
    @Published var attachments: [Attachment]?
    var deletePhase: (() -> Void)?
    
    init(phase: Phase,
         persistenceController: PersistenceController = .shared) {
        self.phase = phase
        self.context = persistenceController.container.viewContext
        self.bindImageChange()
    }
    
    private func bindImageChange() {
        $takenImage
            .sink { image in
                if let image = image {
                    let newImage = Attachment(context: self.context)
                    newImage.image = image.jpegData(compressionQuality: 0.0) ?? Data()
                    self.phase.addToAttachments(newImage)
                    self.attachments = (self.phase.attachments.allObjects as? [Attachment]) ?? []
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchExistingImages() {
        self.attachments = phase.attachments.allObjects as? [Attachment]
    }
    
    func takePicture() {
        self.showCameraView = true
    }
    
    func dataToImage(for attachment: Attachment) -> UIImage? {
        return UIImage(data: attachment.image)
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
}
