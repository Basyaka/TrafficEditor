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
    
    let coreDataMethods = CargoCoreDataMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coreDataMethods.loadCargo()
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.CargoVC.fromCargoToCreateCargo, sender: self)
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
