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
    var contactModel: Contact?
    
    func loadContact(with request: NSFetchRequest<Contact> = Contact.fetchRequest()) {
        do {
            contactArray = try context.fetch(request)
        } catch {
            fatalError()
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
    
    func searchRequest(formatPredicate: String, sortDescriptorKey: String, searchBar: UISearchBar) {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.predicate = NSPredicate(format: formatPredicate, searchBar.text!)
        request.sortDescriptors  = [NSSortDescriptor(key: sortDescriptorKey, ascending: true)]
        loadContact(with: request)
    }
}

//MARK: - Sort Logic
extension ContactCoreDataMethods {
    
    func sortContactAZByLastName() {
        contactArray = contactArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.lastName ?? ""
            let secondContact = secondElement.lastName ?? ""
            return (firstContact.localizedCaseInsensitiveCompare(secondContact) == .orderedAscending)
        }
    }
    
    func sortContactZAByLastName() {
        contactArray = contactArray.sorted { (firstElement, secondElement) -> Bool in
            let firstContact = firstElement.lastName ?? ""
            let secondContact = secondElement.lastName ?? ""
            return (secondContact.localizedCaseInsensitiveCompare(firstContact) == .orderedAscending)
        }
    }
}
