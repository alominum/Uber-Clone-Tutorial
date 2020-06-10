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

private let reuseIdentifier = "LocationCell"

class MainVC: UIViewController {

    
    
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private var user : User? {
        didSet {
            locationInputView.user  = user?
        }
    }
    
    private final let locationInputViewHeight : CGFloat = 200
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        // defined in extension below
        enableLocationServices()
        
        fetchUserData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - API
    
    func fetchUserData(){
        
        Service.shared.fetchUserData(completion: { user in
            self.user = user
            
        })
    }
    
    
    
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
        
        configureInputActiveView()
        configureTableView()
    }
    
    
    func configureInputActiveView(){
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(width: view.frame.width - 32, height: 50)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        inputActivationView.delegate = self
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func configureMapView(){
        
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

            let blackView = LoginMessageView()
            blackView.delegate = self
            view.addSubview(blackView)
            blackView.frame = view.frame
        }
        
    }
    
    func configureLocationInputView(){
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.locationInputView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
            
        }
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        tableView.rowHeight = 60
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height , width: view.frame.width, height: height)
        //removes the lines after the last row
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
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
        
        if status == .authorizedWhenInUse {
            enableLocationServices()
        }
        
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Seved address" : "Nearby"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        
        return cell
    }
    
}

//MARK: - Protocols

extension MainVC: LocationInputViewDelegate {
    func dismissLocationInputView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.locationInputView.alpha = 0
     
            self.tableView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.locationInputView.removeFromSuperview()
        }
  
        UIView.animate(withDuration: 0.4, animations: {
            self.inputActivationView.alpha = 1
        })
        
    }
}

extension MainVC:LoginMessageViewDelegate {
    func loginButtonAction() {
        checkIfUserIsLoggedIn()
    }
}


extension MainVC: LocationInputActivationViewDelegate {

    func presentLocationInputView() {
        UIView.animate(withDuration: 0.2) {
            self.inputActivationView.alpha = 0
        }
        configureLocationInputView()
    }
    
    
}
