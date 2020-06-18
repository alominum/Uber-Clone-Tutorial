//
//  Trip.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-18.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import CoreLocation

enum TripState: Int {
    case requested
    case accepted
    case inProgress
    case completed
}

struct Trip {
    let pickupCoordinates: CLLocationCoordinate2D
    let destinationCoordinates: CLLocationCoordinate2D
    let passengerUid: String
    var driverUid: String?
    var state: TripState!

    init(passengerUid: String, dictionary: [String: Any]){
        self.passengerUid = passengerUid
        
        var lat : CLLocationDegrees = 0.0
        var long : CLLocationDegrees = 0.0
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            if let latt = pickupCoordinates[0] as? CLLocationDegrees {lat = latt}
            if let longg = pickupCoordinates[1] as? CLLocationDegrees {long = longg}
//            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
//            guard let long = pickupCoordinates[1] as? CLLocationDegrees else { return }
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else { self.pickupCoordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            if let latt = destinationCoordinates[0] as? CLLocationDegrees {lat = latt}
            if let longg = destinationCoordinates[1] as? CLLocationDegrees {long = longg}
            //            guard let lat = pickupCoordinates[0] as? CLLocationDegrees else { return }
            //            guard let long = pickupCoordinates[1] as? CLLocationDegrees else { return }
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else { self.destinationCoordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }
        
        self.driverUid = dictionary["driveruid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        } else {self.state = TripState(rawValue: 0)}
        
    }
}


