//
//  Project.swift
//  ATPD
//
//  Created by Francisco F on 3/14/23.
//

import Foundation
import CoreData

struct Project: Hashable {
    let id = UUID().uuidString
    
    var title: String
    var body: String
    var phases: [Phase]
    
    var createdOn: Date
    var changedOn: Date
    var createdBy: String
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return  (lhs.title == rhs.title) &&
                (lhs.body == rhs.body) &&
                (lhs.createdOn == rhs.createdOn) &&
                (lhs.changedOn == rhs.changedOn) &&
                (lhs.createdBy == rhs.createdBy)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func saveToCoreData() throws {
        fatalError("not implemented yet")
    }
    
    static func deserialize(from managedObject: NSManagedObject) throws -> Project {
        fatalError("not implemented yet")
    }
}
