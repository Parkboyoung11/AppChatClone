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
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        label.text = "Welcome You!"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        welcomeLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (time) in
            self.isLogIn()
        }
        
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
