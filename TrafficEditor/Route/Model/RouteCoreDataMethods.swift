//
//  CategoryAndRouteCoreDataMethods.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/28/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class RouteCoreDataMethods {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var routeArray = [Route]()
    var routeModel: Route?
    
    func loadRoute(with request: NSFetchRequest<Route> = Route.fetchRequest()) {
        do {
            routeArray = try context.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    func saveRoute() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
    }
}
