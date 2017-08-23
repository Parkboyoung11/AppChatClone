//
//  WelcomeViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/21/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

let storage = Storage.storage()
let storageRef = storage.reference(forURL: "gs://appchatclone.appspot.com")

var lock : Int = 1

class WelcomeViewController: UIViewController {
    
    init() {
        super.init(nibName: "WelcomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isLogIn()
    }
    
    private func isLogIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.present(TabBarViewController(), animated: true, completion: nil)
            }else {
                print("Dont Log in")
                self.present(LoginViewController(), animated: true, completion: nil)
            }
        }
    }

}
