//
//  LocaionInputActivationView.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-08.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit

class LocationInputActivationView: UIView {
    
    //MARK: - Properties
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderLabel : UILabel = {
        let label = UILabel()
        label.text = "Where to?"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        // Creates shadow around he view
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 1, height:1)
        layer.masksToBounds = false
        
        
        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(width: 6, height: 6)
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
