//
//  Project+CoreDataProperties.swift
//  ATPD
//
//  Created by Francisco F on 3/31/23.
//
//

import Foundation
import CoreData

extension Project {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var body: String
    @NSManaged public var changedOn: Date
    @NSManaged public var createdBy: String
    @NSManaged public var createdOn: Date
    @NSManaged public var title: String
    @NSManaged public var phases: NSSet
}

// MARK: Generated accessors for phases
extension Project {
    @objc(addPhasesObject:)
    @NSManaged public func addToPhases(_ value: Phase)

    @objc(removePhasesObject:)
    @NSManaged public func removeFromPhases(_ value: Phase)

    @objc(addPhases:)
    @NSManaged public func addToPhases(_ values: NSSet)

    @objc(removePhases:)
    @NSManaged public func removeFromPhases(_ values: NSSet)
}

extension Project : Identifiable { }
