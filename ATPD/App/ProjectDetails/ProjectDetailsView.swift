//
//  ProjectDetailsView.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import QuickLook
import SwiftUI

struct ProjectDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectDetailsView(viewmodel: .init(project: .init(title: "My Amazing Project",
                                                               body: "",
                                                               phases: [.init(isComplete: false,
                                                                              title: "Phase One: Start Project",
                                                                              description: "Design the project",
                                                                              attachments: [])],
                                                               createdOn: Date(),
                                                               changedOn: Date(),
                                                               createdBy: "John Smith")))
        }
        .navigationViewStyle(.stack)
    }
}

struct ProjectDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewmodel: ProjectDetailsViewModel
    
    var body: some View {
        projectDataEntry
            .navigationTitle(viewmodel.project.title.isEmpty ? "New Project": viewmodel.project.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    optionsMenu
                }
            }
            .sheet(isPresented: $viewmodel.showCameraView) {
                CameraView(image: $viewmodel.takenImage)
            }
    }
    
    // MARK: - Menu Options
    private var optionsMenu: some View {
        Menu {
            saveProject
            exportAsJsonButton
            exportAsPDFButton
            deleteProject
        } label: {
            Label("Options", systemImage: "circle.grid.3x3.fill")
        }
    }
    
    private var exportAsJsonButton: some View {
        Button {
            // TODO: have the viewmodel create json string, write it out to file system,
            //  show user quicklook preview via url and they can use that to share.
        } label: {
            Label("Export As JSON", systemImage: "doc.plaintext")
        }
    }
    
    private var exportAsPDFButton: some View {
        Button {
            // TODO: have the viewmodel create pdf, write it out to file system,
            //  show user quicklook preview via url and they can use that to share.
        } label: {
            Label("Export As PDF", systemImage: "doc.richtext")
        }
    }
    
    private var deleteProject: some View {
        Button(role: .destructive) {
            viewmodel.deleteProject()
            dismiss()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private var saveProject: some View {
        Button {
            viewmodel.saveProject()
            dismiss()
        } label: {
            Label("Save", systemImage: "arrow.up.circle")
        }
    }
    
    // MARK: - Project Data Entry
    private var projectDataEntry: some View {
        List {
            projectTitleEntry
                .listRowSeparator(.hidden)
            projectBodyEntry
                .listRowSeparator(.hidden)
            phasesEntry
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.immediately)
    }
    
    private var projectTitleEntry: some View {
        GroupBox {
            TextField("", text: $viewmodel.project.title)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
        } label: {
            Text("Project Title").font(.title3).bold()
        }
    }
    
    private var projectBodyEntry: some View {
        GroupBox {
            TextEditor(text: $viewmodel.project.body)
                .font(.title3)
                .lineLimit(3)
                .frame(height: 100)
                .padding(4)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0).stroke(Color.secondary, lineWidth: 0.1)
                }
        } label: {
            Text("Description").font(.title3).bold()
        }
    }
    
    private var phasesEntry: some View {
        GroupBox {
            ForEach(0..<viewmodel.project.phases.count, id: \.self) { index in
                displayPhase(at: index)
            }
        } label: {
            HStack {
                Text("Phases").font(.title3).bold()
                Spacer()
                addButton {
                    viewmodel.addPhase()
                }
            }
        }
    }
    
    private func addButton(withAction action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Label("", systemImage: "plus").font(.title3)
        }
    }
    
    private func displayPhase(at index: Int) -> some View {
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
                    addButton {
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
