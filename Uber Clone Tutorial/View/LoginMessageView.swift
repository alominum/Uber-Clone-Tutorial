//
//  BlackLoginView.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-08.
//  Copyright © 2020 Azrieli. All rights reserved.
//
//
//import UIKit
//
//class LoginMessageView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        let messageLabel : UILabel = {
//            let label = UILabel()
//            label.text = " Please login in to use the app. "
//            label.textColor = .init(white: 1, alpha: 0.8)
//            label.font = UIFont.systemFont(ofSize: 18)
//            label.textAlignment = .center
//            label.numberOfLines = 0
//            return label
//        }()
//
//        let logInButton: AuthButton = {
//            let button = AuthButton(type: .system)
//            button.setTitle("Login", for: .normal)
//            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//            button.addTarget(self, action: #selector(checkIfUserIsLoggedIn), for: .touchUpInside)
//            return button
//        }()
//
//        let backgroundView: UIView = {
//            let view = UIView()
//            view.backgroundColor = .black
//            view.addSubview(messageLabel)
//            view.addSubview(logInButton)
//            messageLabel.centerY(inView: view)
//            messageLabel.centerX(inView: view)
//            logInButton.anchor(top: messageLabel.bottomAnchor, paddingTop: 15, width: 200, height: 50)
//            logInButton.centerX(inView: view)
//            view.accessibilityIdentifier = "blackView"
//            return view
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
