//
//  DriverAnnotation.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-11.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import MapKit

class DriverAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var uid : String

    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.uid = uid
    }
    
    func updateDriverPosition(withCoordinate coordinate: CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
    
}
