//
//  LocationInputView.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-09.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    
    //MARK: - Properties
    
    weak var delegate : LocationInputViewDelegate?
    
    var user : User? {
        didSet {
            titleLabel.text = user?.fullname
        }
    }
    
    private let backButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackButon), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let startingLocationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let linkingView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let destinationLocationIndicatoView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Current location"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isEnabled = false
        
        let paddingView = UIView()
        paddingView.setDimensions(width: 8, height: 30)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private lazy var destinationLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a destinaion"
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        tf.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(width: 8, height: 30)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        return tf
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)

        addSubview(startingLocationTextField)
        startingLocationTextField.centerX(inView: self)
        startingLocationTextField.anchor(top: backButton.bottomAnchor,left: leftAnchor, right:rightAnchor, paddingTop: 12,paddingLeft: 40,paddingRight: 40, height: 30)
        
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor,left: startingLocationTextField.leftAnchor, right: startingLocationTextField.rightAnchor,paddingTop: 12 ,height: 30)
        
        addSubview(startingLocationIndicatorView)
        startingLocationIndicatorView.centerY(inView: startingLocationTextField)
        startingLocationIndicatorView.centerX(inView: backButton)
        startingLocationIndicatorView.setDimensions(width: 6, height: 6)
        startingLocationIndicatorView.layer.cornerRadius = 3
        
        
        addSubview(destinationLocationIndicatoView)
        destinationLocationIndicatoView.centerY(inView: destinationLocationTextField)
        destinationLocationIndicatoView.centerX(inView: backButton)
        destinationLocationIndicatoView.setDimensions(width: 6, height: 6)
        
        addSubview(linkingView)
        linkingView.anchor(top: startingLocationIndicatorView.bottomAnchor,left:startingLocationIndicatorView.leftAnchor,bottom: destinationLocationIndicatoView.topAnchor,right: startingLocationIndicatorView.rightAnchor, paddingTop: 4,paddingLeft: 2.75,paddingBottom: 4,paddingRight: 2.75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helper functions
    
    //MARK: - Selectors
    @objc func handleBackButon(){
        delegate?.dismissLocationInputView()
    }
    
}
