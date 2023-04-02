//
//  Attachment+CoreDataProperties.swift
//  ATPD
//
//  Created by Francisco F on 3/31/23.
//
//

import Foundation
import CoreData

extension Attachment {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var image: Data
    @NSManaged public var phase: Phase
}

extension Attachment : Identifiable {}
