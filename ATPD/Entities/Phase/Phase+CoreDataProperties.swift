//
//  Phase+CoreDataProperties.swift
//  ATPD
//
//  Created by Francisco F on 3/31/23.
//
//

import Foundation
import CoreData


extension Phase {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Phase> {
        return NSFetchRequest<Phase>(entityName: "Phase")
    }

    @NSManaged public var isComplete: Bool
    @NSManaged public var phaseDescription: String
    @NSManaged public var title: String
    @NSManaged public var attachments: NSSet
    @NSManaged public var project: Project
}

// MARK: Generated accessors for attachments
extension Phase {
    @objc(addAttachmentsObject:)
    @NSManaged public func addToAttachments(_ value: Attachment)

    @objc(removeAttachmentsObject:)
    @NSManaged public func removeFromAttachments(_ value: Attachment)

    @objc(addAttachments:)
    @NSManaged public func addToAttachments(_ values: NSSet)

    @objc(removeAttachments:)
    @NSManaged public func removeFromAttachments(_ values: NSSet)
}

extension Phase : Identifiable {}
