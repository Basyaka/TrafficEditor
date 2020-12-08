//
//  UsersCoreDataMethods.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 12/8/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class UsersCoreDataMethods {
    
    static var shared = UsersCoreDataMethods()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loginStorage: [Users]?
    
    func saveUsers(label: UILabel? = nil, text: String? = nil) {
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
    
    func fetchRequestUsers(format: String, argument: String) -> Bool {
    
        do {
            let request = Users.fetchRequest() as NSFetchRequest<Users>
            request.predicate = NSPredicate(format: format, argument)
            loginStorage = try context.fetch(request)
        } catch {
            fatalError()
        }
        
        if loginStorage != [] {
            return true
        } else {
            return false
        }
    }
}
