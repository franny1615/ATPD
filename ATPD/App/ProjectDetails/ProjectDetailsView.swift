//
//  ProjectDetailsView.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

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
        VStack {
            projectDataEntry
        }
        .navigationTitle(viewmodel.project.title.isEmpty ? "New Project": viewmodel.project.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                optionsMenu
            }
        }
    }
    
    // MARK: - Menu Options
    private var optionsMenu: some View {
        Menu {
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
        Button {
            // TODO: viewmodel should delete the project from core data
            dismiss()
        } label: {
            Label("Delete", systemImage: "trash")
                .foregroundColor(Color.red)
        }
    }
    
    // MARK: - Project Data Entry
    private var projectDataEntry: some View {
        Form {
            projectTitleEntry
            projectBodyEntry
            phasesEntry
        }
    }
    
    private var projectTitleEntry: some View {
        Section {
            TextField("", text: $viewmodel.project.title)
                .font(.title3)
        } header: {
            Text("Project Title").font(.title3)
        }
    }
    
    private var projectBodyEntry: some View {
        Section {
            TextEditor(text: $viewmodel.project.body)
                .font(.title3)
                .lineLimit(3)
                .frame(height: 100)
        } header: {
            Text("Description").font(.title3)
        }
    }
    
    private var phasesEntry: some View {
        Section {
            ForEach(0..<viewmodel.project.phases.count, id: \.self) { index in
                displayPhase(at: index)
            }
        } header: {
            HStack {
                Text("Phases").font(.title3)
                Spacer()
                addButton {
                    // TODO: add phase
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
        Form {
            Section {
                TextField("", text: $viewmodel.project.phases[index].title)
                    .font(.title2)
            } header: {
                Text("Phase Title")
                    .font(.title2)
            }
            
            Section {
                TextEditor(text: $viewmodel.project.phases[index].description)
                    .font(.title2)
                    .frame(height: 100)
            } header: {
                Text("Description")
                    .font(.title2)
            }
            
            Section {
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 8.0) {
                        ForEach(viewmodel.project.phases[index].attachments, id: \.self) { base64AttStr in
                            if let data = Data(base64Encoded: base64AttStr),
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                }
                .frame(height: 100)
            } header: {
                HStack {
                    Text("Attachments")
                        .font(.title2)
                    Spacer()
                    addButton {
                        // TODO: add attachment
                    }
                }
            }
        }
        .frame(height: 500)
    }
}
