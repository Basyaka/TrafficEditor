//
//  Cargo+CoreDataProperties.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/30/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//
//

import Foundation
import CoreData


extension Cargo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cargo> {
        return NSFetchRequest<Cargo>(entityName: "Cargo")
    }

    @NSManaged public var cargoImage: Data?
    @NSManaged public var cargoName: String?
    @NSManaged public var cargoType: String?
    @NSManaged public var cargoWeight: Float
    @NSManaged public var invoiceNumber: String?
    @NSManaged public var unloadDate: Date?
    @NSManaged public var uploadDate: Date?

}

extension Cargo : Identifiable {

}