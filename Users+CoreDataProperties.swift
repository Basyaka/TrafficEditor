//
//  Users+CoreDataProperties.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/8/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var routes: NSSet?
    @NSManaged public var contacts: NSSet?
    @NSManaged public var cargoes: NSSet?

}

// MARK: Generated accessors for routes
extension Users {

    @objc(addRoutesObject:)
    @NSManaged public func addToRoutes(_ value: Route)

    @objc(removeRoutesObject:)
    @NSManaged public func removeFromRoutes(_ value: Route)

    @objc(addRoutes:)
    @NSManaged public func addToRoutes(_ values: NSSet)

    @objc(removeRoutes:)
    @NSManaged public func removeFromRoutes(_ values: NSSet)

}

// MARK: Generated accessors for contacts
extension Users {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: Contact)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: Contact)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

// MARK: Generated accessors for cargoes
extension Users {

    @objc(addCargoesObject:)
    @NSManaged public func addToCargoes(_ value: Cargo)

    @objc(removeCargoesObject:)
    @NSManaged public func removeFromCargoes(_ value: Cargo)

    @objc(addCargoes:)
    @NSManaged public func addToCargoes(_ values: NSSet)

    @objc(removeCargoes:)
    @NSManaged public func removeFromCargoes(_ values: NSSet)

}

extension Users : Identifiable {

}
