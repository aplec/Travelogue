//
//  Category+CoreDataProperties.swift
//  Travelogue
//
//  Created by Ante Plecas on 5/7/20.
//  Copyright © 2020 Ante Plecas. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var note: NSOrderedSet?

}

// MARK: Generated accessors for notes
extension Category {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addDocuments:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}
