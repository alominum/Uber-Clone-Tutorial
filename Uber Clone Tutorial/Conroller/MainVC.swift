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
private let driverAnnotationIdentifier = "DriverAnnotation"
private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}


class MainVC: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let tableView = UITableView()
    
    private var actionButtonConfig = ActionButtonConfiguration()
    private let rideActionView = RideActionView()
    private let locationInputView = LocationInputView()
    private let inputActivationView = LocationInputActivationView()
    
    
    private let locationManager = LocaionHandler.shared.locationManager
    private var searchResults = [MKPlacemark]()
    private var route : MKRoute?
    private final let locationInputViewHeight : CGFloat = 200
    private final let rideActionViewHeight : CGFloat = 300
    
    private let actionButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        button.alpha = 0
        return button
    }()
    
    private var user : User? {
        didSet {  locationInputView.user  = user }
    }
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        // defined in extension below
        enableLocationServices()
        
        
        //   signOut()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonPressed(){
        switch actionButtonConfig {
        case .showMenu:
            print("Action button: show menu")
        case .dismissActionView:
            removeAnnotationsAndOverlays()
            animateRideActionView(shouldShow: false)
            configureActionButton(config: .showMenu)
            
            mapView.zoomToFit(annotations: mapView.annotations, top: 150, bottom: 75)
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
            }
        }
        
    }
    
    @objc func dismisAddress(){
        print("DEBUG: dismiss Address..")
    }
    
    // MARK: - API
    
    func fetchDriversInRange(){
        guard let location = locationManager?.location else { return }
        Service.shared.fetchDrivers(location: location, completion: {driver in
            guard let coodinate = driver.location?.coordinate else { return }
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coodinate)
            //add driver location to he map
            self.mapView.addAnnotation(annotation)
        })
    }
    
    func updateMovingDriversPosition(){
        guard let location = locationManager?.location else { return }
        Service.shared.fetchMovingDrivers(location: location, completion: {driver in
            guard let coodinate = driver.location?.coordinate else { return }
            
            //update each driver location to he map
            for annotation in self.mapView.annotations {
                guard let driverAnnotation = annotation as? DriverAnnotation else { return }
                if driverAnnotation.uid == driver.uid {
                    // update possision here
                    driverAnnotation.updateDriverPosition(withCoordinate: coodinate)
                    
                }
            }
        })
    }
    
    func updateExitedDriversPosition(){
        guard let location = locationManager?.location else { return }
        Service.shared.fetchExitedDrivers(location: location, completion: {driver in
            for annotation in self.mapView.annotations {
                guard let driverAnnotation = annotation as? DriverAnnotation else { return }
                if driverAnnotation.uid == driver.uid {
                    //remove annotaion here
                    self.mapView.removeAnnotation(driverAnnotation)
                    
                }
            }
            
            
            
            
            
            
            
        })
    }
    
    
    func fetchUserData(){
        guard let currenUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currenUid, completion: { user in
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
            configure()
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
    
    func configure(){
        configureUI()
        fetchUserData()
        fetchDriversInRange()
        updateMovingDriversPosition()
        updateExitedDriversPosition()
        
    }
    
    
    func configureUI(){
        //        print("DEBUG: Configuring MainVC UI.")
        configureBlackView(status: false)
        
        configureMapView()
        configureActionButton()
        configureInputActionView()
        configureTableView()
        configureRideActionView()
    }
    
    func configureActionButton(){
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 16,paddingLeft: 20,width: 30,height: 30)
    }
    
    func configureRideActionView(){
        view.addSubview(rideActionView)
        rideActionView.delegate = self
        rideActionView.frame = CGRect(x: 0, y: view.frame.height , width: view.frame.width, height: rideActionViewHeight)
    }
    
    func animateRideActionView(shouldShow: Bool,destination: MKPlacemark? = nil){
        
        let yOrigin = shouldShow ? self.view.frame.height - self.rideActionViewHeight : self.view.frame.height
        if shouldShow {
            guard let placemark = destination else { return }
            rideActionView.destination = placemark
        }
        
            UIView.animate(withDuration: 0.3) {
                self.rideActionView.frame.origin.y = yOrigin
            }
    }
    
    
    func configureInputActionView(){
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(width: view.frame.width - 64, height: 50)
        inputActivationView.anchor(top: actionButton.bottomAnchor, paddingTop: 20)
        inputActivationView.delegate = self
        inputActivationView.alpha = 0
        UIView.animate(withDuration: 1.5) {
            self.inputActivationView.alpha = 1
            self.actionButton.alpha = 1
        }
    }
    

    
    func configureBlackView(status on:Bool = false){
        
        for view in self.view.subviews {
            if view.accessibilityIdentifier == "blackView" {
                view.removeFromSuperview()
            }
        }
        
        //        print("DEBUG: Configuring MainVC BlackUI.")
        
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
    
    private func configureActionButton(config: ActionButtonConfiguration){
        switch config {
        case .showMenu:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_menu_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .showMenu
        case .dismissActionView:
            self.actionButton.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
    // A function to dismiss this view but to run from different places.
    func dismissInputActionView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            UIView.animate(withDuration: 0.3, animations: {
                self.locationInputView.alpha = 0
                self.tableView.frame.origin.y = self.view.frame.height
                UIView.animate(withDuration: 0.5, animations: {
                    self.actionButton.alpha = 1
                })
            }) { _ in
                self.locationInputView.removeFromSuperview()
            }
        }, completion: completion)
    }
    
}



//MARK: - extension: UITableViewDelegate, UITableViewDataSource
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Seved address" : "Nearby"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        if indexPath.section == 1{
            cell.placemark = searchResults[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlacemark = searchResults[indexPath.row]
        
        configureActionButton(config: .dismissActionView)
        let destination = MKMapItem(placemark: selectedPlacemark)
        generatePolyline(toDestination: destination)
        
        dismissInputActionView { _ in
            let annotation = MKPointAnnotation()
        
            annotation.coordinate = selectedPlacemark.coordinate
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        
            
            let annotations = self.mapView.annotations.filter ({ !$0.isKind(of: DriverAnnotation.self)})
            
            self.mapView.zoomToFit(annotations: annotations, top: 75, bottom: 300)
            self.animateRideActionView(shouldShow: true,destination: selectedPlacemark)
            
            
        }
        

    }
}


//MARK: - extension: MapView and location service

extension MainVC : MKMapViewDelegate {
    
    func enableLocationServices(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            //asks for access to location (when in use)
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            //updates the location and set the accuracy to best
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            //asks for access to location (always)
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func configureMapView(){
        
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    // Defines custome anooationView for drivers
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: driverAnnotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        return nil
    }
    
    // after you generate the route needs to set your polyline here
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .mainBlueTint
            lineRenderer.lineWidth = 4
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
}

//MARK: - Mapview helper functions

private extension MainVC{
    
    func searchBy(naturalLanguageQuery: String, completion : @escaping([MKPlacemark]) -> Void) {
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            if let err = error {
                print("DEBUG: error while searching for a places: \(err.localizedDescription)")
                return
            }
            guard let response = response else { return }
            
            response.mapItems.forEach { (item) in
                results.append(item.placemark)
            }
            completion(results)
        }
    }
    
    func generatePolyline(toDestination destination: MKMapItem){
        // defines the source and destination of a request
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        // send the request and asks for direction
        let directionRequest = MKDirections(request: request)
        // calculates the directions
        directionRequest.calculate { (response, error) in
            if let err = error {
                print("DEBUG: Error while calculation direction to destination: \(err)")
                return
            }
            
            guard let resp = response else { return }
            self.route = resp.routes[0]
            guard let polyline = self.route?.polyline else { return }
            self.mapView.addOverlay(polyline)
  
        }
        
    }
    
    func removeAnnotationsAndOverlays(){
        mapView.annotations.forEach { (annotation) in
            if let anno = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(anno)
            }
        }
        
        if mapView.overlays.count > 0 {
            mapView.removeOverlays(mapView.overlays)
        }
        
        
        
    }
}

//MARK: - extension: Local Protocols

extension MainVC: LocationInputViewDelegate {
    
    func dismissLocationInputView() {
        
        dismissInputActionView { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.inputActivationView.alpha = 1
            })
        }
        
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
            self.actionButton.alpha = 0
        }
        configureLocationInputView()
    }
    func executeSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { results in
            self.searchResults = results
            self.tableView.reloadData()
        }
    }
}

extension MainVC : RideActionViewDelegate {
    func handleConfirmUberXButton() {
        
    }
}
