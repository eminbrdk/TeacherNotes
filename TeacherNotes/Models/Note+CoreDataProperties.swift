//
//  Note+CoreDataProperties.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: Double
    @NSManaged public var point: Int16
    @NSManaged public var text: String?
    @NSManaged public var student: Student?

}

extension Note : Identifiable {

}
