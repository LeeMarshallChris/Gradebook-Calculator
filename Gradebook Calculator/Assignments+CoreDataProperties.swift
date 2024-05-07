//
//  Assignments+CoreDataProperties.swift
//  Gradebook Calculator
//
//  Created by  on 5/3/24.
//
//

import Foundation
import CoreData


extension Assignments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignments> {
        return NSFetchRequest<Assignments>(entityName: "Assignments")
    }

    @NSManaged public var assignmentTitle: String?
    @NSManaged public var pointsGiven: Double
    @NSManaged public var pointsTotal: Double
    @NSManaged public var courseTitle: String?
    @NSManaged public var course: SchoolCourse?

}

extension Assignments : Identifiable {

}
