//
//  RouteViewTableViewCell.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 11/28/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var pointA: UILabel!
    @IBOutlet weak var pointB: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
