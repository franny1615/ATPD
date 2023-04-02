//
//  PhaseView.swift
//  ATPD
//
//  Created by Francisco F on 3/25/23.
//

import SwiftUI

struct PhaseDetailsView: View {
    @StateObject var viewModel: PhaseDetailsViewModel
    
    var body: some View {
        GroupBox {
            VStack(spacing: 8) {
                TextEditor(text: $viewModel.phase.phaseDescription)
                    .font(.title3)
                    .lineLimit(3)
                    .frame(height: 100)
                    .padding(4)
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color.secondary, lineWidth: 0.1)
                    }
                
                HStack {
                    Text("Attachments")
                        .font(.title3).bold()
                    Spacer()
                    ViewHelper.addButton {
                        viewModel.takePicture()
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 8.0) {
                        ForEach(0..<viewModel.attachments.count, id: \.self) { index in
                            if let uiImage = viewModel.dataToImage(for: viewModel.attachments[index]) {
                                Button {
                                    viewModel.previewImage(uiImage: uiImage)
                                } label: {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 95, height: 95)
                                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                }
                                .quickLookPreview($viewModel.previewUrl)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.delete(viewModel.attachments[index])
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                
                Toggle(isOn: $viewModel.phase.isComplete, label: {
                    Text("Completed?").font(.title3).bold()
                })
            }
        } label: {
            HStack {
                TextField("Enter a phase title",
                          text: $viewModel.phase.title,
                          prompt: Text("Phase Title"))
                .font(.title3).bold()
                
                Spacer()
                
                Button(role: .destructive) {
                    viewModel.deletePhase?()
                } label: {
                    Label("", systemImage: "trash")
                }
            }
        }
        .onAppear {
            viewModel.fetchExistingImages()
        }
        .sheet(isPresented: $viewModel.showCameraView) {
            CameraView(image: $viewModel.takenImage)
        }
    }
}
