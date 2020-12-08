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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewForSearchAndSort: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchControl: UISegmentedControl!
    
    let sharedContact = ContactCoreDataMethods.shared
    
    private var sortBool = true
    // we set a variable to hold the contentOffSet before scroll view scrolls
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sharedContact.loadContact()
        sortButton.setTitle("A-Z", for: .normal)
        sharedContact.sortContactAZByLastName()
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.ContactVC.fromContactToCreateContact, sender: self)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        switch sortBool {
        case true: //ZA
            sortBool = false
            sortButton.setTitle("Z-A", for: .normal)
            sharedContact.sortContactZAByLastName()
            tableView.reloadData()
        case false: //AZ
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            sharedContact.sortContactAZByLastName()
            tableView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension ContactViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchControl.selectedSegmentIndex == 0 { //last name
            sharedContact.searchRequest(formatPredicate: "lastName CONTAINS[cd] %@", sortDescriptorKey: "lastName", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 1 { //driver id
            sharedContact.searchRequest(formatPredicate: "driverID CONTAINS[cd] %@", sortDescriptorKey: "driverID", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 2 { //car number
            sharedContact.searchRequest(formatPredicate: "carNumber CONTAINS[cd] %@", sortDescriptorKey: "carNumber", searchBar: searchBar)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            sharedContact.loadContact()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedContact.contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.contactCell, for: indexPath) as! ContactTableViewCell
        
        cell.firstName.text = sharedContact.contactArray[indexPath.row].firstName
        cell.lastName.text = sharedContact.contactArray[indexPath.row].lastName
        
        if let data = sharedContact.contactArray[indexPath.row].avatarImage {
            cell.avatarImage.image = UIImage(data: data)
        } else {
            cell.avatarImage.image = UIImage(systemName: "person.circle")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.sharedContact.context.delete(ContactCoreDataMethods.shared.contactArray[indexPath.row])
            self.sharedContact.contactArray.remove(at: indexPath.row)
            self.sharedContact.saveContact()
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
        if let indexPath = tableView.indexPathsForSelectedRows?.first {
            sharedContact.contactModel = ContactCoreDataMethods.shared.contactArray[indexPath.row]
        }
    }
    
    //MARK: - Table View Scroll Logic
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            viewForSearchAndSort.isHidden = false
            //            tableView.topAnchor.constraint(equalTo: viewForSearchAndSort.topAnchor).isActive = true
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            viewForSearchAndSort.isHidden = true
            //            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            //        } else {
            // didn't move
            //            viewForSearchAndSort.isHidden = false
            //            tableView.topAnchor.constraint(equalTo: viewForSearchAndSort.topAnchor).isActive = true
        }
    }
}

//MARK: - Castomization
extension ContactViewController {
    func setUpElements() {
        sortButton.layer.cornerRadius = 10
    }
}
