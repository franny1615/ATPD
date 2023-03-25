//
//  ViewHelper.swift
//  ATPD
//
//  Created by Francisco F on 3/25/23.
//

import SwiftUI

class ViewHelper {
    static func addButton(withAction action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Label("", systemImage: "plus").font(.title3)
        }
    }
}
