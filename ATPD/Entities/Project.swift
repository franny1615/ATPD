//
//  Project.swift
//  ATPD
//
//  Created by Francisco F on 3/14/23.
//

import Foundation
import CoreData

struct Project: Hashable {
    var title: String
    var body: String
    var attachments: NSData
    
    var createdOn: Date
    var changedOn: Date
    var createdBy: String
    
    static func deserialize(from managedObject: NSManagedObject) throws -> Project {
        return .init(title: managedObject.value(forKey: "") as! String,
                     body: managedObject.value(forKey: "") as! String,
                     attachments: managedObject.value(forKey: "") as! NSData,
                     createdOn: managedObject.value(forKey: "") as! Date,
                     changedOn: managedObject.value(forKey: "") as! Date,
                     createdBy: managedObject.value(forKey: "") as! String)
    }
}
