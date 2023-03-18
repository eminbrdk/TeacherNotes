//
//  CoreDataManagement.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit
import CoreData


struct CoreDataManagement {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteData(data: NSManagedObject) {
        context.delete(data)
        
        do { try context.save() } catch { return }
    }
    
}
