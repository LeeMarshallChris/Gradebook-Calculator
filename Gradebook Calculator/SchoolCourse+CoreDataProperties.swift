//
//  SchoolCourse+CoreDataProperties.swift
//  Gradebook Calculator
//
//  Created by  on 5/3/24.
//
//

import Foundation
import CoreData


extension SchoolCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SchoolCourse> {
        return NSFetchRequest<SchoolCourse>(entityName: "SchoolCourse")
    }

    @NSManaged public var courseTitle: String?
    @NSManaged public var assignments: NSSet?

}

// MARK: Generated accessors for assignments
extension SchoolCourse {

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: Assignments)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: Assignments)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSSet)

}

extension SchoolCourse : Identifiable {

}
