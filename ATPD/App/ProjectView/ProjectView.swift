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
        VStack {
            Text("Hello World")
        }
    }
}
