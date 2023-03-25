//
//  PhaseView.swift
//  ATPD
//
//  Created by Francisco F on 3/25/23.
//

import SwiftUI

struct PhaseView: View {
    @ObservedObject var viewmodel: ProjectDetailsViewModel
    @State var index: Int
    
    var body: some View {
        GroupBox {
            VStack(spacing: 8) {
                TextEditor(text: $viewmodel.project.phases[index].description)
                    .font(.title3)
                    .lineLimit(3)
                    .frame(height: 100)
                    .padding(4)
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5.0).stroke(Color.secondary, lineWidth: 0.1)
                    }
                    .foregroundColor(viewmodel.project.phases[index].description == phaseDescPlaceholder ? .secondary: .primary)
                    .onTapGesture {
                        viewmodel.project.phases[index].description = ""
                    }
                
                HStack {
                    Text("Attachments")
                        .font(.title3).bold()
                    Spacer()
                    ViewHelper.addButton {
                        viewmodel.takePictureForPhase(at: index)
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 8.0) {
                        ForEach(viewmodel.project.phases[index].attachments, id: \.self) { uiImage in
                            Button {
                                viewmodel.previewImage(uiImage: uiImage)
                            } label: {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 95, height: 95)
                                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                            }
                            .quickLookPreview($viewmodel.previewUrl)
                        }
                    }
                }
                .frame(height: 100)
            }
        } label: {
            HStack {
                TextField("Enter a phase title",
                          text: $viewmodel.project.phases[index].title,
                          prompt: Text("Phase Title"))
                .font(.title3).bold()
                
                Spacer()
                
                Button(role: .destructive) {
                    viewmodel.deletePhase(at: index)
                } label: {
                    Label("", systemImage: "trash")
                }
            }
        }
    }
}
