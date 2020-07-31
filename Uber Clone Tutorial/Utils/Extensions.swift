//
//  Extensions.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-05-12.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import UIKit
import MapKit

//MARK: - UIColor

extension UIColor {
    func rgb(red: CGFloat,green: CGFloat,blue: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static let backgroundColor = UIColor().rgb(red: 25, green: 25, blue: 25)
    static let mainBlueTint = UIColor().rgb(red: 17, green: 154, blue: 237)
    
}

//MARK: - UIView

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
    
    func centerX(inView view: UIView, paddingX: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: paddingX).isActive = true
    }

    func centerY(inView view: UIView, paddingY: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: paddingY).isActive = true

    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0 ,paddingY: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: paddingY).isActive = true
        if let left = leftAnchor {
            anchor(left: left , paddingLeft: paddingLeft )
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 1, height:1)
        layer.masksToBounds = false
    }
}

//MARK: - TextField

extension UITextField {
    func textField(withPlaceHolder placeHolder: String, isSecuredTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .white
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecuredTextEntry
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return tf
    }
    
    func isAnEmailAddress(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}

//MARK: - UIApplication

extension UIApplication {

    /// The app's key window taking into consideration apps that support multiple scenes.
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first(where: { $0.isKeyWindow })
    }

}

//MARK: - MKPlacemark
extension MKPlacemark {
    var address : String? {
        guard let subThoroughfare = subThoroughfare else { return nil }
        guard let thoroughfare = thoroughfare else { return nil }
        guard let locality = locality else { return nil }
        guard let adminArea = administrativeArea else { return nil }
        return "\(subThoroughfare) \(thoroughfare), \(locality), \(adminArea)"
    }
}

//MARK: - MKMapView

extension MKMapView {
    func zoomToFit(annotations: [MKAnnotation],top: CGFloat,bottom: CGFloat){
        var zoomRect = MKMapRect.null
        
        annotations.forEach { (annotation) in
            let annotationpoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationpoint.x, y: annotationpoint.y, width: 0.01, height: 0.01)
            // unions the zoomRect with the new one
            zoomRect = zoomRect.union(pointRect)
        }
        // defines the rect we need to zoom in on the screen
        let insets = UIEdgeInsets(top: top, left: 75, bottom: bottom, right: 75)
        setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
    }
}

//MARK: -  UIViewController

extension UIViewController {
    func shouldPresentLoadingView(_ present: Bool, message : String? = nil){
        if present {
            let loadingView = UIView()
            loadingView.frame = self.view.frame
            loadingView.backgroundColor = .black
            loadingView.alpha = 0
            loadingView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.style = .large
            indicator.color = .white
            indicator.center = loadingView.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .white
            label.alpha = 0.87
            label.textAlignment = .center
            
            loadingView.addSubview(indicator)
            loadingView.addSubview(label)
            self.view.addSubview(loadingView)

            
            label.centerX(inView: self.view)
            label.anchor(top: indicator.bottomAnchor, paddingTop: 32)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.3) {
                loadingView.alpha = 0.7
            }
        } else {
            view.subviews.forEach { (subView) in
                if subView.tag == 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        subView.alpha = 0
                    }) { _ in
                        subView.removeFromSuperview()
                    }

                }
            }
        }
    }
    
}
