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
    
    let sharedCargo = CargoCoreDataMethods.shared
    
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
        sharedCargo.loadCargo()
        sortBool = true
        sortButton.setTitle("A-Z", for: .normal)
        sharedCargo.sortCargoAZByName()
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
            sharedCargo.sortCargoZAByName()
            tableView.reloadData()
        case false: //AZ
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            sharedCargo.sortCargoAZByName()
            tableView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension CargoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchControl.selectedSegmentIndex == 0 { //Name
            sharedCargo.searchRequest(formatPredicate: "cargoName CONTAINS[cd] %@", sortDescriptorKey: "cargoName", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 1 { //Type
            sharedCargo.searchRequest(formatPredicate: "cargoType CONTAINS[cd] %@", sortDescriptorKey: "cargoType", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 2 { //Invoice ID
            sharedCargo.searchRequest(formatPredicate: "invoiceNumber CONTAINS[cd] %@", sortDescriptorKey: "invoiceNumber", searchBar: searchBar)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            sharedCargo.loadCargo()
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            sharedCargo.sortCargoAZByName()
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
        return sharedCargo.cargoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.cargoCell, for: indexPath) as! CargoTableViewCell
        cell.cargoNameLabel.text = sharedCargo.cargoArray[indexPath.row].cargoName
        cell.cargoTypeLabel.text = sharedCargo.cargoArray[indexPath.row].cargoType
        
        if let data = CargoCoreDataMethods.shared.cargoArray[indexPath.row].cargoImage {
            cell.cargoImageView.image = UIImage(data: data)
        } else {
            cell.cargoImageView.image = UIImage(systemName: "folder.circle")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.sharedCargo.context.delete(self.sharedCargo.cargoArray[indexPath.row])
            self.sharedCargo.cargoArray.remove(at: indexPath.row)
            self.sharedCargo.saveCargo()
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
        if let indexPath = tableView.indexPathForSelectedRow {
            sharedCargo.cargoModel = sharedCargo.cargoArray[indexPath.row]
        }
    }
}

//MARK: - Castomization
extension CargoViewController {
    func setUpElements() {
        sortButton.layer.cornerRadius = 10
    }
}
