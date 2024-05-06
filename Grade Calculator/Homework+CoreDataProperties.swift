//
//  Homework+CoreDataProperties.swift
//  Grade Calculator
//
//  Created by  on 5/1/24.
//
//

import Foundation
import CoreData


extension Homework {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Homework> {
        return NSFetchRequest<Homework>(entityName: "Homework")
    }

    @NSManaged public var homeworkTitle: String?
    @NSManaged public var pointsGiven: Double
    @NSManaged public var pointsTotal: Double
    @NSManaged public var schoolcourse: SchoolCourse?

}

extension Homework : Identifiable {

}
