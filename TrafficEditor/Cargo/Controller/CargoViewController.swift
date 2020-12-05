//
//  CargoViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class CargoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForSearchAndSort: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchControl: UISegmentedControl!
    
    let coreDataMethods = CargoCoreDataMethods()
    
    private var sortBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coreDataMethods.loadCargo()
        sortButton.setTitle("A-Z", for: .normal)
        coreDataMethods.sortCargoAZByName()
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.CargoVC.fromCargoToCreateCargo, sender: self)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        switch sortBool {
        case true: //ZA
            sortBool = false
            sortButton.setTitle("Z-A", for: .normal)
            coreDataMethods.sortCargoZAByName()
            tableView.reloadData()
        case false: //AZ
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            coreDataMethods.sortCargoAZByName()
            tableView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension CargoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchControl.selectedSegmentIndex == 0 { //Name
            coreDataMethods.searchRequest(formatPredicate: "cargoName CONTAINS[cd] %@", sortDescriptorKey: "cargoName", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 1 { //Type
            coreDataMethods.searchRequest(formatPredicate: "cargoType CONTAINS[cd] %@", sortDescriptorKey: "cargoType", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 2 { //Invoice ID
            coreDataMethods.searchRequest(formatPredicate: "invoiceNumber CONTAINS[cd] %@", sortDescriptorKey: "invoiceNumber", searchBar: searchBar)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            coreDataMethods.loadCargo()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CargoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMethods.cargoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cargoCell, for: indexPath) as! CargoTableViewCell
        cell.cargoNameLabel.text = coreDataMethods.cargoArray[indexPath.row].cargoName
        cell.cargoTypeLabel.text = coreDataMethods.cargoArray[indexPath.row].cargoType
        
        if let data = coreDataMethods.cargoArray[indexPath.row].cargoImage {
            cell.cargoImageView.image = UIImage(data: data)
        } else {
            cell.cargoImageView.image = UIImage(systemName: "folder.circle")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.coreDataMethods.context.delete(self.coreDataMethods.cargoArray[indexPath.row])
            self.coreDataMethods.cargoArray.remove(at: indexPath.row)
            self.coreDataMethods.saveCargo()
            self.tableView.reloadData()
        }
        swipeDelete.backgroundColor = .red
        swipeDelete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.CargoVC.fromCargoToViewAndEditCargo, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.CargoVC.fromCargoToViewAndEditCargo {
            let destinationVC = segue.destination as! CargoViewAndEditViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.coreDataMethods.cargoModel = coreDataMethods.cargoArray[indexPath.row]
            }
        }
    }
}

//MARK: - Castomization
extension CargoViewController {
    func setUpElements() {
        sortButton.layer.cornerRadius = 10
    }
}
