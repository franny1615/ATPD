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
        let context = PersistenceController.shared.container.viewContext
        NavigationView {
            ProjectDetailsView(viewmodel: .init(project: .init(context: context)))
        }
        .navigationViewStyle(.stack)
    }
}

struct ProjectDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewmodel: ProjectDetailsViewModel
    @State private var previewUrl: URL?
    @FocusState private var inFocus: Int?
    
    var body: some View {
        projectDataEntry
            .navigationTitle(viewmodel.project.title.isEmpty ? "New Project": viewmodel.project.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewmodel.deleteProjectIfEmpty() {
                            dismiss()
                        }
                    } label: {
                        Label("", systemImage: "arrow.backward")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    optionsMenu
                }
            }
            .alert(viewmodel.error?.domain ?? "Error",
                   isPresented: $viewmodel.showError) {
                Button("OK") { }
            } message: {
                Text(viewmodel.error?.localizedDescription ?? "Some error occurred without description.")
            }
            .navigationBarBackButtonHidden()
            .quickLookPreview($previewUrl)
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
            if let jsonString = viewmodel.convertProjectToJSON(),
               let savedJsonFileURL = viewmodel.save(jsonString) {
                self.previewUrl = savedJsonFileURL
            }
        } label: {
            Label("Export As JSON", systemImage: "doc.plaintext")
        }
    }
    
    private var exportAsPDFButton: some View {
        Button {
            if let pdfData = viewmodel.generatePDF(),
               let pdfURL = viewmodel.savePDF(pdfData) {
                self.previewUrl = pdfURL
            }
        } label: {
            Label("Export As PDF", systemImage: "doc.richtext")
        }
    }
    
    private var deleteProject: some View {
        Button(role: .destructive) {
            if viewmodel.deleteProject() {
                dismiss()
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private var saveProject: some View {
        Button {
            if viewmodel.saveProject() {
                dismiss()
            }
        } label: {
            Label("Save", systemImage: "arrow.up.circle")
        }
    }
    
    // MARK: - Project Data Entry
    private var projectDataEntry: some View {
        ScrollViewReader { reader in
            ScrollView(.vertical) {
                projectTitleEntry.id(0)
                    .focused($inFocus, equals: 0)
                createdByEntry.id(1)
                    .focused($inFocus, equals: 1)
                projectBodyEntry.id(2)
                    .focused($inFocus, equals: 2)
                phasesEntry
                
                if let inFocus = inFocus, inFocus == ((viewmodel.phases.count - 1) + 3) {
                    Color.clear.frame(height: 300)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: inFocus) { id in
                withAnimation {
                    reader.scrollTo(id)
                }
            }
        }
        .padding([.leading, .trailing], 8.0)
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
    
    private var createdByEntry: some View {
        GroupBox {
            TextField("", text: $viewmodel.project.createdBy)
                .font(.title3)
                .textFieldStyle(.roundedBorder)
        } label: {
            Text("Created By").font(.title3).bold()
        }
    }
    
    private var projectBodyEntry: some View {
        GroupBox {
            TextEditor(text: $viewmodel.project.body)
                .font(.title3)
                .lineLimit(3)
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
            ForEach(0..<viewmodel.phases.count, id: \.self) { phaseIndex in
                PhaseDetailsView(viewModel: viewmodel.getPhaseDetailsViewModel(for: viewmodel.phases[phaseIndex])).id(phaseIndex + 3)
                    .focused($inFocus, equals: phaseIndex + 3)
            }
        } label: {
            HStack {
                Text("Phases").font(.title3).bold()
                Spacer()
                ViewHelper.addButton {
                    viewmodel.addPhase()
                }
            }
        }
    }
}
