//
//  ContactViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 9/23/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coreDataMethods = ContactCoreDataMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coreDataMethods.loadContact()
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.ContactVC.fromContactToCreateContact, sender: self)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMethods.contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.contactCell, for: indexPath) as! ContactTableViewCell
        
        cell.firstName.text = coreDataMethods.contactArray[indexPath.row].firstName
        cell.lastName.text = coreDataMethods.contactArray[indexPath.row].lastName
        
        if let data = coreDataMethods.contactArray[indexPath.row].avatarImage {
            cell.avatarImage.image = UIImage(data: data)
        } else {
            cell.avatarImage.image = UIImage(systemName: "person.fill")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.coreDataMethods.context.delete(self.coreDataMethods.contactArray[indexPath.row])
            self.coreDataMethods.contactArray.remove(at: indexPath.row)
            self.coreDataMethods.saveContact()
            tableView.reloadData()
        }
        swipeDelete.backgroundColor = .red
        swipeDelete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.ContactVC.fromContactToViewAndEditContact, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.ContactVC.fromContactToViewAndEditContact {
            let destinationVC = segue.destination as! ContactViewAndEditViewController
            if let indexPath = tableView.indexPathsForSelectedRows?.first {
                destinationVC.contactViewModel = coreDataMethods.contactArray[indexPath.row]
            }
        }
    }
}

