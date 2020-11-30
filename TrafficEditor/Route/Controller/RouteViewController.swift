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
    
    let coreDataMethods = RouteCoreDataMethods()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coreDataMethods.loadRoute()
        tableView.reloadData()
  
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.RouteVC.fromRouteToEditingRoute, sender: self)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataMethods.routeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Cells.routeCell, for: indexPath) as! RouteTableViewCell
        cell.pointA.text = coreDataMethods.routeArray[indexPath.row].pointA
        cell.pointB.text = coreDataMethods.routeArray[indexPath.row].pointB
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDelete = UIContextualAction(style: .normal, title: "Delete") { (action, view, success) in
            self.coreDataMethods.context.delete(self.coreDataMethods.routeArray[indexPath.row])
            self.coreDataMethods.routeArray.remove(at: indexPath.row)
            self.coreDataMethods.saveRoute()
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
        if segue.identifier == K.Segues.RouteVC.fromRouteToViewAndEditRoute {
            let destinationVC = segue.destination as! RouteViewAndEditViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.coreDataMethods.routeModel = coreDataMethods.routeArray[indexPath.row]
            }
        }
    }
    
}
