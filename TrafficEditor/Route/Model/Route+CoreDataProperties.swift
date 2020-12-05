//
//  Route+CoreDataProperties.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/28/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var distanceRoute: String?
    @NSManaged public var pointA: String?
    @NSManaged public var pointB: String?
    @NSManaged public var uploadDate: Date?
    @NSManaged public var unloadDate: Date?
    @NSManaged public var routeNumber: String?
}

extension Route : Identifiable {

}
