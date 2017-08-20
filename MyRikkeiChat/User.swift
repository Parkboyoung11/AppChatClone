//
//  User.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/16/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id : String!
    let email : String!
    let fullName : String!
    let photoURL : String!
    var avatar : UIImage!
    
    init() {
        id = ""
        email = ""
        fullName = ""
        photoURL = ""
        avatar = UIImage(named: "personicon")
    }
    
    init(id: String , email: String, fullName: String, photoURL: String) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.photoURL = photoURL
        self.avatar = UIImage(named: "personicon")
    }
}

