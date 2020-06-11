//
//  SignupVC.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-05-12.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class SignupVC: UIViewController {
    
    
    // MARK: - Properies
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.font = UIFont(name: "Avenir-Light", size: 36)
        return label
    }()
    
    private var location = LocaionHandler.shared.locationManager.location
    private let emailTextField : UITextField = {
        let view = UITextField().textField(withPlaceHolder: "Email", isSecuredTextEntry: false)
        return view
    }()
    
    private lazy var emailContainerView : UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let fullNameTextField : UITextField = {
        let view = UITextField().textField(withPlaceHolder: "Full Name", isSecuredTextEntry: false)
        return view
    }()
    
    
    private lazy var fullnameContainerView : UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    
    private let passwordTextField : UITextField = {
        let view = UITextField().textField(withPlaceHolder: "Password", isSecuredTextEntry: true)
        return view
    }()
    
    
    private lazy var passwordContainerView : UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let accountTypeSC : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider","Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var accountTypeContainerView : UIView = {
        let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControll: accountTypeSC)
        view.heightAnchor.constraint(equalToConstant: 85).isActive = true
        return view
    }()
    
    let signupButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignupButton), for: .touchUpInside)
        return button
    }()
    
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Alredy have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureUI()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        configureUI()
    //    }
    //
    
    
    // MARK: - Selectors
    
    @objc func handleShowLogin(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSignupButton(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        let accountTypeIndex = accountTypeSC.selectedSegmentIndex
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print("DEBUG: Error happend when registering a new user: \(err.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            if accountTypeIndex == 1 {
                if let location = self.location {
                    geofire.setLocation(location, forKey: uid) { err in
                        
                    }
                }
            }
            
            let values = ["email" : email,
                          "fullname" : fullName,
                          "accountType" : accountTypeIndex] as [String : Any]
            
            REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                if let err = err {
                    print("DEBUG: Error registerig user data in users database: \(err.localizedDescription)")
                    return
                }
                
                print("DEBUG: User registered and data has been saved.")
                
                
                // Configure UI in the mainVC
                guard let vc = UIApplication.shared.windows.first?.rootViewController?.children.first as? MainVC else { return }
                vc.configureUI()
                
                // Goes to root VC
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
                
            }
            
            
            
            
        }
    }
    
    // MARK: - Helper functions
    
    func configureUI(){
        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        
        // Add subviews
        view.addSubview(titleLabel)
        
        
        // Add constraints
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        // Deine and add Stack
        let stack = UIStackView(arrangedSubviews: [emailContainerView,fullnameContainerView,passwordContainerView,accountTypeContainerView,signupButton])
        //        let stack = UIStackView(arrangedSubviews: [emailContainerView])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        // add go to login button
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, height: 32)
        
    }
    
    func configureNavBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
}
