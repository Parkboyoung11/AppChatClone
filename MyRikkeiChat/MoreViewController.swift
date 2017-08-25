//
//  MoreViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/18/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

class MoreViewController: UIViewController {
    
    init() {
        super.init(nibName: "MoreViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Information"
    }
    
    @IBAction func btnLogoutDid(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            currentUser = nil
            visitor = nil
            indexSS = -1
            present(LoginViewController(), animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
