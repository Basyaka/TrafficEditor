//
//  RouteViewController.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/5/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForSearchAndSort: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchControl: UISegmentedControl!
    
    let sharedRoute = RouteCoreDataMethods.shared
    
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
        sharedRoute.loadRoute()
        sortBool = true
        sortButton.setTitle("A-Z", for: .normal)
        sharedRoute.sortRouteAZByPointA()
        tableView.reloadData()
  
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.RouteVC.fromRouteToEditingRoute, sender: self)
    }
        
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        switch sortBool {
        case true: //ZA
            sortBool = false
            sortButton.setTitle("Z-A", for: .normal)
            sharedRoute.sortRouteZAByPointA()
            tableView.reloadData()
        case false: //AZ
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            sharedRoute.sortRouteAZByPointA()
            tableView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension RouteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchControl.selectedSegmentIndex == 0 { //PointA
            sharedRoute.searchRequest(formatPredicate: "pointA CONTAINS[cd] %@", sortDescriptorKey: "pointA", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 1 { //PointB
            sharedRoute.searchRequest(formatPredicate: "pointB CONTAINS[cd] %@", sortDescriptorKey: "pointB", searchBar: searchBar)
            tableView.reloadData()
        } else if searchControl.selectedSegmentIndex == 2 { //Route Number
            sharedRoute.searchRequest(formatPredicate: "routeNumber CONTAINS[cd] %@", sortDescriptorKey: "routeNumber", searchBar: searchBar)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            sharedRoute.loadRoute()
            sortBool = true
            sortButton.setTitle("A-Z", for: .normal)
            sharedRoute.sortRouteAZByPointA()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension RouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedRoute.routeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.routeCell, for: indexPath) as! RouteTableViewCell
        
        if let pointAString = sharedRoute.routeArray[indexPath.row].pointA {
            cell.pointA.text = "From: \(pointAString)"
        }
        
        if let pointBString = sharedRoute.routeArray[indexPath.row].pointB {
            cell.pointB.text = "To: \(pointBString)"
        }
        
        if let distanceString = sharedRoute.routeArray[indexPath.row].distanceRoute {
            cell.distanceLabel.text = "\(distanceString) km"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.sharedRoute.context.delete(self.sharedRoute.routeArray[indexPath.row])
            self.sharedRoute.routeArray.remove(at: indexPath.row)
            self.sharedRoute.saveRoute()
            self.tableView.reloadData()
        }
        swipeDelete.backgroundColor = .red
        swipeDelete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.RouteVC.fromRouteToViewAndEditRoute, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let indexPath = tableView.indexPathForSelectedRow {
                sharedRoute.routeModel = sharedRoute.routeArray[indexPath.row]
            }
    }
}

//MARK: - Castomization
extension RouteViewController {
    func setUpElements() {
        sortButton.layer.cornerRadius = 10
    }
}

