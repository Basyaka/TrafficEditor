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
        static let fromCategoryToRoute = "fromCategoryToRoute"
        
        struct RouteVC {
            static let fromRouteToViewRoute = "fromRouteToViewRoute"
            static let fromRouteToEditingRoute = "fromRouteToEditRoute"
        }
        
        struct ContactVC {
            static let fromContactToCreateContact = "fromContactToCreateContact"
            static let fromContactToViewAndEditContact = "fromContactToViewAndEditContact"
        }
        
        struct CargoVC {
            static let fromCargoToViewCargo = "fromCargoToViewCargo"
            static let fromCargoToEditCargo = "fromCargoToEditCargo"
        }
        
        struct CarVC {
            static let fromCarToViewCar = "fromCarToViewCar"
            static let stafromCarToEditCar = "fromCarToEditCar"
        }
        
    }
    
    struct Cells {
        static let categoryCell = "CategoryCell"
        static let contactCell = "ContactCell"
    }
    
    struct Storyboard {
         static let mainViewContoller = "MainVC"
    }
    
    struct Image {
        static let eyeSlash = "eye.slash"
        static let eye = "eye"
    }
}
