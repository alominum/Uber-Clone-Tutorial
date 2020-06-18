//
//  RideActionView.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-17.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit
import MapKit

protocol RideActionViewDelegate: class {
    func uploadTrip(_ view : RideActionView)
}

class RideActionView: UIView {
    
    //MARK: - Properties
    
    var destination: MKPlacemark? {
        didSet{
            titleLable.text = destination?.name
            addressLabel.text = destination?.address
        }
    }
    weak var delegate: RideActionViewDelegate?
    
    private let titleLable : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test Address Title"
        label.textAlignment = .center
        return label
        
    }()
    
    private let addressLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "129 Flamingo drive, Beaconsfield,QC"
        return label
    }()
    

    
    private lazy var infoView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        let label = UILabel()
        label.text = "X"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        return view
    }()
    
    private let uberXLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "UberX"
        label.textAlignment = .center
        return label
        
    }()
    
    private let seperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("CONFIRM UBERX", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(infoView)
        infoView.centerX(inView: self)
        backgroundColor = .white
        addShadow()
        
        let stack = UIStackView(arrangedSubviews: [titleLable,addressLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: topAnchor, paddingTop: 12)
        stack.centerX(inView: self)
        
        infoView.anchor(top: stack.bottomAnchor, paddingTop: 16,width: 70,height: 70)
        infoView.layer.cornerRadius = 70/2
        
        addSubview(uberXLabel)
        uberXLabel.centerX(inView: self)
        uberXLabel.anchor(top: infoView.bottomAnchor, paddingTop: 8)
        
        addSubview(seperatorView)
        seperatorView.anchor(top: uberXLabel.bottomAnchor, left: leftAnchor,right: rightAnchor, paddingTop: 8 , paddingLeft: 8, paddingRight: 8 ,height: 0.75)
        
        addSubview(actionButton)
        actionButton.anchor(left: leftAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,right: rightAnchor, paddingLeft: 20, paddingBottom: 24,paddingRight: 20, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper functions
    
    //MARK: - Selectors
    @objc func actionButtonPressed(){
        delegate?.uploadTrip(self)
    }
}
