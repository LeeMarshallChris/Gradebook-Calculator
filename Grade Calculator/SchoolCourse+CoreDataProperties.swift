//
//  SchoolCourse+CoreDataProperties.swift
//  Grade Calculator
//
//  Created by  on 5/1/24.
//
//

import Foundation
import CoreData


extension SchoolCourse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SchoolCourse> {
        return NSFetchRequest<SchoolCourse>(entityName: "SchoolCourse")
    }

    @NSManaged public var courseTitle: String?
    @NSManaged public var homework: NSSet?

}

// MARK: Generated accessors for homework
extension SchoolCourse {

    @objc(addHomeworkObject:)
    @NSManaged public func addToHomework(_ value: Homework)

    @objc(removeHomeworkObject:)
    @NSManaged public func removeFromHomework(_ value: Homework)

    @objc(addHomework:)
    @NSManaged public func addToHomework(_ values: NSSet)

    @objc(removeHomework:)
    @NSManaged public func removeFromHomework(_ values: NSSet)

}

extension SchoolCourse : Identifiable {

}
