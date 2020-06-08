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

    let mapView = MKMapView()
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        checkIfUserIsLoggedIn()
 //     signOut()
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in")
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
        view.backgroundColor = .none
        //-----------------------------------
        let looutButton: AuthButton = {
            let button = AuthButton(type: .system)
            button.setTitle("Logout", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
            return button
        }()
        
        //-----------------------------------
        
        view.addSubview(mapView)
        view.addSubview(looutButton)
        mapView.frame = view.frame
        looutButton.anchor(top: view.topAnchor, left: view.leftAnchor,paddingTop: 50,paddingLeft: 20, width: 200, height: 50)
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
