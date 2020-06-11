//
//  LocaionHandler.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-10.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import CoreLocation

class LocaionHandler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocaionHandler()
    var locationManager : CLLocationManager!
    var location : CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // to run send the second request righ away
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    
}
