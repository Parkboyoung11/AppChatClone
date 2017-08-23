//
//  ListChatViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/17/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

var currentUser:User!
var ref: DatabaseReference!

class ListChatViewController: UIViewController {
    @IBOutlet weak var tblConversations: UITableView!
    
    init() {
        super.init(nibName: "ListChatViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Conversations"
        tblConversations.register(UINib(nibName: "ConversarionTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        tblConversations.dataSource = self
        tblConversations.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            let name = user.displayName
            currentUser = User(id: uid, email: email!, fullName: name!, photoURL: String(describing: photoURL!))
            print(lock)
            if lock == 1 {
                print("-----aaaaaaaa-------")
                let tableName = ref.child("users")
                let userid = tableName.child(currentUser.id)
                let user : Dictionary<String,String> = ["email": currentUser.email, "uid": currentUser.id , "fullName": currentUser.fullName, "photoURL": currentUser.photoURL]
                userid.setValue(user)
                print("Creat Database Succeeded")
            }
            
            let url:URL = URL(string: currentUser.photoURL)!
            do{
                let data = try Data(contentsOf: url)
                currentUser.avatar = UIImage(data: data)
                print("Get Avatar Succeeded")
            }catch{
                print("Get Avatar Failed")
            }
        }else {
            print("No Current User")
        }
        
    }
    
}


extension ListChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ConversarionTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
