//
//  Constants.swift
//  TrafficEditor
//
//  Created by Vlad Novik on 9/23/20.
//  Copyright © 2020 Vlad Novik. All rights reserved.
//

import Foundation

struct K {
    
    struct Segues {
        
        static let toMainViewController = "toMainVC"
        
        struct RouteVC {
            static let fromRouteToViewAndEditRoute = "fromRouteToViewAndEditRoute"
            static let fromRouteToEditingRoute = "fromRouteToCreateRoute"
        }
        
        struct ContactVC {
            static let fromContactToCreateContact = "fromContactToCreateContact"
            static let fromContactToViewAndEditContact = "fromContactToViewAndEditContact"
        }
        
        struct CargoVC {
            static let fromCargoToViewAndEditCargo = "fromCargoToViewAndEditCargo"
            static let fromCargoToCreateCargo = "fromCargoToCreateCargo"
        }
    }
    
    struct Cells {
        static let categoryCell = "CategoryCell"
        static let contactCell = "ContactCell"
        static let routeCell = "RouteCell"
        static let cargoCell = "CargoCell"
    }
    
    struct Storyboard {
         static let mainViewContoller = "MainVC"
    }
    
    struct Image {
        static let eyeSlash = "eye.slash"
        static let eye = "eye"
    }
}
