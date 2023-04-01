//
//  ProjectView.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import SwiftUI

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(viewmodel: .init())
    }
}

struct ProjectView: View {
    @ObservedObject var viewmodel: ProjectViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                projectList
            }
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addProjectButton
                }
            }
            .onAppear {
                viewmodel.fetchProjectsFromCoreData()
            }
            .alert(viewmodel.error?.domain ?? "",
                   isPresented: $viewmodel.showError,
                   actions: {
                dismissErrorButton
            }, message: {
                Text(viewmodel.error?.localizedDescription ?? "")
            })
        }
        .navigationViewStyle(.stack)
    }
    
    private var projectList: some View {
        List {
            ForEach(0..<viewmodel.projects.count, id: \.self) { index in
                NavigationLink(destination: {
                    ProjectDetailsView(viewmodel: viewmodel.getProjectDetailsVM(for: viewmodel.projects[index]))
                }, label: {
                    display(viewmodel.projects[index])
                })
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
        }
        .listStyle(.plain)
    }
    
    private func display(_ project: Project) -> some View {
        VStack {
            Text(project.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .font(.title2.bold())
            HStack {
                Text("by \(project.createdBy)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.title3.italic())
                Spacer()
                Text(project.changedOn.toString(withFormat: "MM/dd/yyyy hh:mm:ss a"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.title3)
            }
        }
        .padding([.leading, .trailing], 8.0)
        .padding([.top, .bottom], 4.0)
        .background { Color(uiColor: .systemGray5) }
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
        .contextMenu {
            Button(role: .destructive) {
                if viewmodel.delete(project) {
                    viewmodel.fetchProjectsFromCoreData()
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var dismissErrorButton: some View {
        Button {
            viewmodel.showError = false
        } label: {
            Text("OK")
        }
    }
    
    private var addProjectButton: some View {
        NavigationLink(destination: {
            ProjectDetailsView(viewmodel: viewmodel.getProjectDetailsVM())
        }, label: {
            Label("Add", systemImage: "plus")
        })
    }
}
