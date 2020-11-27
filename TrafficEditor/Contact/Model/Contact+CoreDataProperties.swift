//
//  Contact+CoreDataProperties.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/28/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var avatarImage: Data?
    @NSManaged public var carModel: String?
    @NSManaged public var carNumber: String?
    @NSManaged public var carrying: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var driverID: String?
    @NSManaged public var experience: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    
}

extension Contact : Identifiable {

}
