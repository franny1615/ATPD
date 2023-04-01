//
//  Checklist.swift
//  ATPD
//
//  Created by Francisco F on 3/18/23.
//

import CoreData
import Foundation

@objc(Phase)
class Phase: NSManagedObject, Encodable {
    enum CodingKeys: String, CodingKey {
        case description
        case title
        case isCompleted
        case addedOn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.phaseDescription, forKey: .description)
        try container.encode(self.isComplete, forKey: .isCompleted)
        try container.encode(self.addedOn.toString(withFormat: "MM-dd-yyyy hh:mm:ss a"),
                             forKey: .addedOn)
    }
}
