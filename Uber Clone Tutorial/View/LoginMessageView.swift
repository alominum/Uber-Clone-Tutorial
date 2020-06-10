//
//  BlackLoginView.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-08.
//  Copyright © 2020 Azrieli. All rights reserved.
//
//
import UIKit

protocol LoginMessageViewDelegate: class {
    func loginButtonAction()
}


class LoginMessageView: UIView {

    
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
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    weak var delegate : LoginMessageViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .black
        addSubview(messageLabel)
        addSubview(logInButton)
        messageLabel.centerY(inView: self)
        messageLabel.centerX(inView: self)
        logInButton.anchor(top: messageLabel.bottomAnchor, paddingTop: 15, width: 200, height: 50)
        logInButton.centerX(inView: self)
        accessibilityIdentifier = "blackView"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func loginButtonAction(){
        delegate?.loginButtonAction()
    }
}
