//
//  Students+CoreDataProperties.swift
//  
//
//  Created by DreamOnline Ltd on 12/10/21.
//
//

import Foundation
import CoreData


extension Students {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Students> {
        return NSFetchRequest<Students>(entityName: "Students")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var birthday: String?
    @NSManaged public var roll: Int32
    @NSManaged public var password: String?
    @NSManaged public var fathername: String?
    @NSManaged public var student_class: Int32

}
