//
//  LocationLocal.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/8/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class LocationLocal : Location {

  static  var sharedLocationInstance : Location = Location(context: context)
    
    override func awakeFromNib() {
        
    }
    

}
