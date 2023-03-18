//
//  Class+CoreDataProperties.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//
//

import Foundation
import CoreData


extension Class {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Class> {
        return NSFetchRequest<Class>(entityName: "Class")
    }

    @NSManaged public var date: Double
    @NSManaged public var name: String?
    @NSManaged public var students: NSSet?

}

// MARK: Generated accessors for students
extension Class {

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: Student)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: Student)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSSet)

}

extension Class : Identifiable {

}
