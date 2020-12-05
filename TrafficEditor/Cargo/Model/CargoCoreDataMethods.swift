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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var cargoArray = [Cargo]()
    var cargoModel: Cargo?
    
    func loadCargo(with request: NSFetchRequest<Cargo> = Cargo.fetchRequest()) {
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
        request.predicate = NSPredicate(format: formatPredicate, searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: sortDescriptorKey, ascending: true)]
        loadCargo(with: request)
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
