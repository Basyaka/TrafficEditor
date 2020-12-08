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
    
    static let shared = ContactCoreDataMethods()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactArray = [Contact]()
    var contactCheckingStorage: [Contact]?
    var contactModel: Contact?
    var account: Users?
    
    func loadContact(with request: NSFetchRequest<Contact> = Contact.fetchRequest()) {
        
        request.predicate = NSPredicate(format: "parentUser.username MATCHES %@", account!.username!)
        
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
    
    func checkingFetchRequest(format: String, argument: String) -> Bool {
        do {
            let request = Contact.fetchRequest() as NSFetchRequest<Contact>
            request.predicate = NSPredicate(format: format, argument)
            contactCheckingStorage = try context.fetch(request)
        } catch {
            fatalError()
        }
        
        if contactCheckingStorage != [] {
            return true
        } else {
            return false
        }
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
