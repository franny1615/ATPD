//
//  Project.swift
//  ATPD
//
//  Created by Francisco F on 3/14/23.
//

import CoreData
import Foundation

@objc(Project)
class Project: NSManagedObject, Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case phases
        case createdBy
        case lastChangedOn
        case createdOn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.body, forKey: .description)
        try container.encode(self.createdBy, forKey: .createdBy)
        try container.encode(self.createdOn.toString(withFormat: "MM-dd-yyyy hh:mm:ss a"),
                             forKey: .createdOn)
        try container.encode(self.changedOn.toString(withFormat: "MM-dd-yyyy hh:mm:ss a"),
                             forKey: .lastChangedOn)
        
        let phases = (self.phases.allObjects as? [Phase]) ?? []
        try container.encode(phases, forKey: .phases)
    }
}
