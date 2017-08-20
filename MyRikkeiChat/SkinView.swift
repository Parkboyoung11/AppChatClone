//
//  SkinView.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/16/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIView {
    func myViewSkin() {
        self.layer.borderColor = UIColor.yellow.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
}

extension UIButton {
    func myButtonSkin() {
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.tintColor = UIColor.red
        self.backgroundColor = UIColor.white
    }
}

extension UIImageView {
    func myImageSkin() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.brown.cgColor
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    func loadAvatar(link: String) {
        let queue = DispatchQueue(label: "Load Image", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        activity.frame = CGRect(x: self.frame.size.width/2, y: self.frame.size.height/2, width: 0, height: 0)
        activity.color = #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1)
        self.addSubview(activity)
        activity.startAnimating()
        queue.async {
            let url:URL = URL(string: link)!
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    activity.stopAnimating()
                    self.image = UIImage(data: data)
                }
            }catch {
                activity.stopAnimating()
                print("Load Avatar Error")
            }
            
        }
    }
}

extension UITextField {
    func myTextFieldSkin() {
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextFieldViewMode.whileEditing
        self.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    }
}
