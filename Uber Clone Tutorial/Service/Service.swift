//
//  Service.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-09.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")
let REF_TRIPS = DB_REF.child("trips")

struct Service {
    
    static let shared = Service()
    
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snap) in
            guard let dictionary = snap.value as? [String: Any] else { return }
            let uid = snap.key
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        //        REF_DRIVER_LOCATIONS.observe(.value) { (snapShot) in
        geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
            self.fetchUserData(uid: uid) { (user) in
                var driver = user
                driver.location = location
                completion(driver)
            }
        })
        //        }
        
    }
    
    func fetchMovingDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        geofire.query(at: location, withRadius: 5).observe(.keyMoved, with: { (uid, location) in
            self.fetchUserData(uid: uid) { (user) in
                var driver = user
                driver.location = location
                completion(driver)
            }
        })
        
    }
    
    func fetchExitedDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        geofire.query(at: location, withRadius: 5).observe(.keyExited, with: { (uid, location) in
            self.fetchUserData(uid: uid) { (user) in
                var driver = user
                driver.location = location
                completion(driver)
            }
        })
        
    }
    
    func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, pickupCoordinates.longitude]
        let destinationArray = [destinationCoordinates.latitude,destinationCoordinates.longitude]
        
        let values = ["pickupCoordinates" : pickupArray,
                      "destinationCoordinates": destinationArray,
                      "state" : TripState.requested.rawValue] as [String : Any]
                      
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTrip(completion: @escaping(Trip) -> Void){
        REF_TRIPS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["driverUid" : uid, "state": TripState.accepted.rawValue] as [String : Any]
        REF_TRIPS.child(trip.passengerUid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func observeCurrentTrip(completion: @escaping(Trip) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_TRIPS.child(uid).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
}
