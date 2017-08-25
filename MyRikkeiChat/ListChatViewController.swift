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
var indexSS : Int  = -1

class ListChatViewController: UIViewController {
    @IBOutlet weak var tblConversations: UITableView!
    
    init() {
        super.init(nibName: "ListChatViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tblConversations.reloadData()
    }
    
    var mesIDList = [[String]]()
    var membersIDList = [[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Conversations"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addConversationButtonDid)), animated: true)
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
            if lock == 1 {
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
            
            
            var count : Int = 0
//            var count2 : Int = 0
            
            
            let tableID = ref.child("user-conversations").child(currentUser.id)
            tableID.observe(.childAdded, with: { (snapshot) in
                let conversationid = snapshot.value as! String
                
                let tableMembers = ref.child("conversations").child(conversationid).child("members")
                tableMembers.observe(.childAdded, with: { (snapshot2) in
                    DispatchQueue.main.async {
                        if count == 0 {
                            print("---------")
                            print(indexSS)
                            print("-----------")
                            indexSS += 1
                            self.membersIDList.append(["startmember"])
                            self.mesIDList.append(["startmes"])
//                            if count2 != 0 {
                                self.tblConversations.reloadData()
//                            }
//                            count2 += 1
                        }
                        count += 1
                        if snapshot2.key != currentUser.id {
                            print(indexSS)
                            
                            self.membersIDList[indexSS].append(snapshot2.key)
                            print("---------members----------")
                            print(self.membersIDList)
                            print("\n")
                        }
                    }
                })
                
                let tableMesID = ref.child("conversations").child(conversationid).child("messages")
                tableMesID.observe(.childAdded, with: { (snapshot3) in
                    DispatchQueue.main.async {
//                        count = 0
                        self.mesIDList[indexSS].append(snapshot3.key)
                        print("---------mesID----------")
                        print(self.mesIDList)
                        print("\n")
                    }
                    
                })
                
                let tableSubVoVan = ref.child("conversations").child(conversationid)
                tableSubVoVan.observe(.childAdded, with: { (snsd) in
                    DispatchQueue.main.async {
                        count = 0
                    }
                })
            })
            
        }else {
            print("No Current User")
        }
        
    }
    
    func addConversationButtonDid() {
//        navigationController?.pushViewController(AddFriendViewController(), animated: true)
    }
    
}


extension ListChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mesIDList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! ConversarionTableViewCell
        
        ref.child("messages").child(mesIDList[indexPath.row][mesIDList[indexPath.row].count-1]).child("content").observeSingleEvent(of: .value, with: { (snapshot) in
            cell.lblChat.text = snapshot.value as? String
        }) { (error) in
            print(error.localizedDescription)
        }
        var membersName : String = ""
        for i in 1..<membersIDList[indexPath.row].count {
            ref.child("users").child(membersIDList[indexPath.row][i]).child("fullName").observeSingleEvent(of: .value, with: { (snapshot) in
                let memberName = snapshot.value as! String
                if membersName != "" {
                    membersName = membersName + ", " + memberName
                }else {
                    membersName = memberName
                }
                
                cell.lblName.text = membersName
            }) { (error) in
                print(error.localizedDescription)
            }
            
            ref.child("users").child(membersIDList[indexPath.row][i]).child("photoURL").observeSingleEvent(of: .value, with: { (snapshot) in
                let photoURL = snapshot.value as! String
                cell.imgAvatar.loadAvatar(link: photoURL)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
