//
//  ProjectView.swift
//  ATPD
//
//  Created by Francisco F on 3/13/23.
//

import SwiftUI

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(viewmodel: .init(projects: [.init(title: "Amazing Cool Project",
                                                      body: "",
                                                      attachments: NSData(),
                                                      createdOn: Date(),
                                                      changedOn: Date(),
                                                      createdBy: "John Smith")]))
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
            ForEach(viewmodel.projects, id: \.self) { project in
                NavigationLink(destination: {
                    ProjectDetailsView(viewmodel: viewmodel.getProjectDetailsVM(for: project))
                }, label: {
                    display(project)
                })
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
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
                .font(.system(size: 24, weight: .bold))
            HStack {
                Text("by \(project.createdBy)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.system(size: 16, weight: .regular).italic())
                Spacer()
                Text(project.changedOn.toString(withFormat: "MM/dd/yyyy hh:mm:ss a"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .font(.system(size: 16, weight: .regular))
            }
        }
        .padding([.leading, .trailing], 8.0)
        .padding([.top, .bottom], 4.0)
        .background { Color(uiColor: .systemGray5) }
        .clipShape(RoundedRectangle(cornerRadius: 5.0))
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