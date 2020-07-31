//
//  PickupVC.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-07-28.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

protocol PickupVCDelegate : class {
    func didAcceptTrip(_ trip: Trip)
}

class PickupVC: UIViewController {
    //MARK: - Properties
    private let mapView = MKMapView()
    
    weak var delegate : PickupVCDelegate?
    
    let trip : Trip
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let pickupLabel : UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let acceptTripButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept trip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(acceptTrip), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Life cycle
    
    // How initialize a VC with an object
    init(trip : Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
        configureMapView()
        
    }
    //MARK: - Selectors
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func acceptTrip(){
        Service.shared.acceptTrip(trip: trip) { (error, ref) in
            var tripLocal = self.trip
            print(ref)
            tripLocal.driverUid = Auth.auth().currentUser?.uid
            tripLocal.state = .accepted
            self.delegate?.didAcceptTrip(tripLocal)
//            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper functions
    func configureMapView(){
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        
        let anno = MKPointAnnotation()
        anno.coordinate = trip.pickupCoordinates
        mapView.addAnnotation(anno)
        mapView.selectAnnotation(anno, animated: true)
    }
    
    
    
    func configureUI(){
        view.backgroundColor = .backgroundColor
        
        view.addSubview(cancelButton)
        cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 6 , paddingLeft: 16, width: 25, height: 25)
        
        view.addSubview(mapView)
        let radius = view.frame.width * 0.70
        mapView.setDimensions(width: ( radius ),height: radius)
        mapView.centerX(inView: self.view)
        mapView.centerY(inView: view, paddingY: -150)
        mapView.layer.cornerRadius = radius / 2
        
        view.addSubview(pickupLabel)
        pickupLabel.anchor(top: mapView.bottomAnchor, paddingTop: 25)
        pickupLabel.centerX(inView: view)
        
        view.addSubview(acceptTripButton)
        acceptTripButton.anchor(top: pickupLabel.bottomAnchor, paddingTop: 15)
        acceptTripButton.centerX(inView: view)
        acceptTripButton.setDimensions(width: radius, height: 50)
        
    }
    
    //MARK: - API
}
