//
//  CargoTableViewCell.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/29/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class CargoTableViewCell: UITableViewCell {

    @IBOutlet weak var cargoImageView: UIImageView!
    @IBOutlet weak var cargoNameLabel: UILabel!
    @IBOutlet weak var cargoTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cargoImageView.layer.cornerRadius = 35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
