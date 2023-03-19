//
//  Checklist.swift
//  ATPD
//
//  Created by Francisco F on 3/18/23.
//

import Foundation

struct Phase: Hashable {
    var isComplete: Bool
    var title: String
    var description: String
    var attachments: [String]
}
