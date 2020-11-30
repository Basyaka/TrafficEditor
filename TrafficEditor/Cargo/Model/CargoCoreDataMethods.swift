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
}
