//
//  Extensions.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-05-12.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit

extension UIColor {
    func rgb(red: CGFloat,green: CGFloat,blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor().rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor().rgb(red: 17, green: 154, blue: 237)
    
}

extension UIView {
    
    func inputContainerView(image: UIImage, textField: UITextField? = nil, segmentedControll : UISegmentedControl? = nil) -> UIView {
        let view = UIView()
        
        // add image view
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 0.87
        view.addSubview(imageView)

        
        // Add textField to this view
        if let textField = textField {
            imageView.centerY(inView: view)
            imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24,height: 24)
            
            view.addSubview(textField)
            textField.anchor(left: imageView.rightAnchor,right: view.rightAnchor,paddingLeft: 8,paddingRight: 8)
            textField.centerY(inView: view)
        }
        // Add segmented conroll to this view
        if let segmentedControll = segmentedControll {
            imageView.anchor(top: view.topAnchor,left: view.leftAnchor,paddingTop: 8,paddingLeft: 8,width: 24,height: 24)
            view.addSubview(segmentedControll)
            segmentedControll.anchor(top: imageView.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor,paddingTop: 8, paddingLeft: 8,paddingRight: 8)
//            segmentedControll.centerY(inView: view)

        }
        
        // Add seperator view
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,paddingBottom: 10 ,height: 0.75)
        
        return view
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left:NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom : CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, padding: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: padding).isActive = true
    }
    
    func centerY(inView view: UIView, padding: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: padding).isActive = true
    }
}


extension UITextField {
    func textField(withPlaceHolder placeHolder: String, isSecuredTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return tf
    }
}
