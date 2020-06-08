//
//  MainVCViewController.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-05-15.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class MainVC: UIViewController {
    
    
    
    // MARK: - Properties
    
    private let mapView : MKMapView = {
        let map = MKMapView()
        map.accessibilityIdentifier = "map"
        return map
    }()
    
    private let inputActivationView = LocationInputActivationView()
    private let locationManager = CLLocationManager()
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        // defined in extension below
        enableLocationServices()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - API
    
    @objc func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in")
            configureBlackView(status: true)
            DispatchQueue.main.async {
                self.present(LoginVC(), animated: true, completion: nil)
                
            }
            
        } else {
            // User is logged in
            configureUI()
        }
    }
    
    @objc func signOut() {
        do {
            view.backgroundColor = .black
            try Auth.auth().signOut()
            print("DEBUG: User signed out.")
            
            checkIfUserIsLoggedIn()
        } catch {
            print("DEBUG: Error while signing out: \(error.localizedDescription) ")
        }
    }
    // MARK: - Helper Functions
    
    
    
    func configureUI(){
        print("DEBUG: Configuring MainVC UI.")
        configureBlackView(status: false)
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(width: view.frame.width - 32, height: 50)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
        }
        
    }
    
    func configureMapView(){
//        view.backgroundColor = .none
        
        view.addSubview(mapView)
    
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
    }
    
    func configureBlackView(status on:Bool = false){
    
            for view in self.view.subviews {
                if view.accessibilityIdentifier == "blackView" {
                    view.removeFromSuperview()
                }
            }
        
        print("DEBUG: Configuring MainVC BlackUI.")
        
        if on {
            let messageLabel : UILabel = {
                let label = UILabel()
                label.text = " Please login in to use the app. "
                label.textColor = .init(white: 1, alpha: 0.8)
                label.font = UIFont.systemFont(ofSize: 18)
                label.textAlignment = .center
                label.numberOfLines = 0
                return label
            }()
            let logInButton: AuthButton = {
                let button = AuthButton(type: .system)
                button.setTitle("Login", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                button.addTarget(self, action: #selector(checkIfUserIsLoggedIn), for: .touchUpInside)
                return button
            }()
            
            let blackView: UIView = {
                let view = UIView()
                view.backgroundColor = .black
                view.addSubview(messageLabel)
                view.addSubview(logInButton)
                messageLabel.centerY(inView: view)
                messageLabel.centerX(inView: view)
                logInButton.anchor(top: messageLabel.bottomAnchor, paddingTop: 15, width: 200, height: 50)
                logInButton.centerX(inView: view)
                view.accessibilityIdentifier = "blackView"
                return view
            }()

            view.addSubview(blackView)
            blackView.frame = view.frame
        }
        
    }
    
    
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - Location services extension

extension MainVC: CLLocationManagerDelegate{
    
    func enableLocationServices(){
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //asks for access to location (when in use)
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            //updates the location and set the accuracy to best
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            //asks for access to location (always)
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    // to run send the second request righ away
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
//        if status == .authorizedWhenInUse {
            enableLocationServices()
//        }
        
    }
}
