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
    
    func searchRequest(formatPredicate: String, sortDescriptorKey: String, searchBar: UISearchBar) {
        let request: NSFetchRequest<Route> = Route.fetchRequest()
        request.predicate = NSPredicate(format: formatPredicate, searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: sortDescriptorKey, ascending: true)]
        loadRoute(with: request)
    }
}

//MARK: - Sort Logic
extension RouteCoreDataMethods {
    
    func sortRouteAZByPointA() {
        routeArray = routeArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.pointA ?? ""
            let secondContact = secondElement.pointA ?? ""
            return (firstContact.localizedCaseInsensitiveCompare(secondContact) == .orderedAscending)
        }
    }
    
    func sortRouteZAByPointA() {
        routeArray = routeArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.pointA ?? ""
            let secondContact = secondElement.pointA ?? ""
            return (secondContact.localizedCaseInsensitiveCompare(firstContact) == .orderedAscending)
        }
    }
}
