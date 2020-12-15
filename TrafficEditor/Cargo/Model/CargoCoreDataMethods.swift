//
//  CargoCoreDataMethods.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/30/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class CargoCoreDataMethods {
    
    static let shared = CargoCoreDataMethods()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cargoArray = [Cargo]()
    var cargoCheckingStorage: [Cargo]?
    var cargoModel: Cargo?
    var account: Users?
    
    func loadCargo(with request: NSFetchRequest<Cargo> = Cargo.fetchRequest(), predicate: NSPredicate?  = nil) {
        
        let parentPredicate = NSPredicate(format: "parentUser.username MATCHES %@", account!.username!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentPredicate, additionalPredicate])
        } else {
            request.predicate = parentPredicate
        }
        
        do {
            cargoArray = try context.fetch(request)
        } catch {
            print("Error reading: \(error)")
        }
    }
    
    func saveCargo() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
    }
    
    func searchRequest(formatPredicate: String, sortDescriptorKey: String, searchBar: UISearchBar) {
        let request: NSFetchRequest<Cargo> = Cargo.fetchRequest()
        let predicate = NSPredicate(format: formatPredicate, searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: sortDescriptorKey, ascending: true)]
        loadCargo(with: request, predicate: predicate)
    }
    
    func checkingFetchRequest(format: String, argument: String) -> Bool {
        do {
            let request = Cargo.fetchRequest() as NSFetchRequest<Cargo>
            request.predicate = NSPredicate(format: format, argument)
            cargoCheckingStorage = try context.fetch(request)
        } catch {
            fatalError()
        }
        
        if cargoCheckingStorage != [] {
            return true
        } else {
            return false
        }
    }
}

//MARK: - Sort Logic
extension CargoCoreDataMethods {
    
    func sortCargoAZByName() {
        cargoArray = cargoArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.cargoName ?? ""
            let secondContact = secondElement.cargoName ?? ""
            return (firstContact.localizedCaseInsensitiveCompare(secondContact) == .orderedAscending)
        }
    }
    
    func sortCargoZAByName() {
        cargoArray = cargoArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.cargoName ?? ""
            let secondContact = secondElement.cargoName ?? ""
            return (secondContact.localizedCaseInsensitiveCompare(firstContact) == .orderedAscending)
        }
    }
}
