//
//  DataManager.swift
//  SIMS
//
//  Created by DreamOnline Ltd on 12/10/21.
//

import Foundation
import CoreData
import UIKit

class DataManager: NSObject {
    
    static let shared = DataManager()
    
    var loggedInUser: Students? = nil
    
    func login(email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let fetchRequest = Students.fetchRequest()

        // Create the component predicates
        let namePredicate = NSPredicate(
            format: "email LIKE %@", email
        )

        let planetPredicate = NSPredicate(
            format: "password = %@", password
        )

        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                namePredicate,
                planetPredicate
            ]
        )

        // Get a reference to a NSManagedObjectContext
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch request to get the objects
        // matching the compound predicate
        if let objects = try? context.fetch(fetchRequest) {
            if objects.count > 0 {
                self.loggedInUser = objects[0]
                completion(true)
                //self.showAlert(title: "Error", message: "User not found")
            } else {
                completion(false)
            }
        }
    }
    
    func getAlldata(completion: @escaping (_ success: Bool, _ data: [NSManagedObject]) -> Void) {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
       
        let fetchRequest = Students.fetchRequest()

        // Create the component predicates
        let namePredicate = NSPredicate(
            format: "email != %@", Constants.ADMIN_EMAIL
        )

        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                namePredicate
            ]
        )
        
        do {
         let allUsers = try managedContext.fetch(fetchRequest)
            completion(true, allUsers)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            completion(false, [])
        }
    }
    
    func isExist(email: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let fetchRequest = Students.fetchRequest()

        // Create the component predicates
        let namePredicate = NSPredicate(
            format: "email LIKE %@", email
        )


        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                namePredicate
            ]
        )

        // Get a reference to a NSManagedObjectContext
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch request to get the objects
        // matching the compound predicate
        if let objects = try? context.fetch(fetchRequest) {
            completion(objects.count > 0)
        }
    }
    
    func getCurrentUserData(email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let fetchRequest = Students.fetchRequest()
        fetchRequest.fetchLimit = 1
        // Create the component predicates
        let namePredicate = NSPredicate(
            format: "email LIKE %@", email
        )


        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                namePredicate
            ]
        )

        // Get a reference to a NSManagedObjectContext
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch request to get the objects
        // matching the compound predicate
        if let objects = try? context.fetch(fetchRequest) {
            if objects.count > 0 {
                self.loggedInUser = objects[0]
            }
        }
    }
    
    func saveData(email: String, password: String, name: String, fathersName: String, birthDay: String, studentClass: Int, roll: Int, profileImage: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Students", in: managedContext) {
            let person = NSManagedObject(entity: entity, insertInto: managedContext)
            
            person.setValue(email, forKeyPath: "email")
            person.setValue(password, forKeyPath: "password")
            person.setValue(fathersName, forKeyPath: "fathername")
            person.setValue(name, forKeyPath: "name")
            person.setValue(birthDay, forKeyPath: "birthday")
            person.setValue(studentClass, forKeyPath: "student_class")
            person.setValue(roll, forKeyPath: "roll")
            if let image = profileImage {
                person.setValue(image.jpegData(compressionQuality:1.0), forKey: "profileImage")
            }
            do {
                try managedContext.save()
                 completion(true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                completion(false)
            }
        }
        
    }
    
    func removeData(object: NSManagedObject) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(object)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }
    
    func updateData(object: NSManagedObject) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")
        }
    }
    
    
}
