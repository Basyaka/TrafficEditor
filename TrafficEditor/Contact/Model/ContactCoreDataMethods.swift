//
//  ContactCoreDataMethods.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/24/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import CoreData
import UIKit

class ContactCoreDataMethods {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactArray = [Contact]()
    
    func loadContact(with request: NSFetchRequest<Contact> = Contact.fetchRequest()) {
        do {
            contactArray = try context.fetch(request)
        } catch {
            print("Error reading: \(error)")
        }
    }
    
    func saveContact(label: UILabel? = nil, text: String? = nil) {
        do {
            try context.save()
            label?.text = text
            label?.textColor = .green
            label?.alpha = 1
        } catch {
            label?.text = error.localizedDescription
            label?.textColor = .red
            label?.alpha = 1
        }
    }
}
