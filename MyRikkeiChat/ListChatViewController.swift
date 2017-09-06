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
    
    let tblConversations : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var menuView : UIView = {
        let view = UIView()
        return view
    }()
    
    let profileLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "PROFILE"
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var fullNameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var emailLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var friendCountLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "You don't have any friends"
        label.numberOfLines = 1
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let devInforLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "@VuHongSon9fury\nvuhongsonjv11@gmail.com\n+84 971 034 608"
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoutButton : UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.05117796371, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let avatarImage : UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 70
        avatar.contentMode = .scaleAspectFill
        avatar.layer.borderColor = UIColor.gray.cgColor
        avatar.layer.borderWidth = 0.5
        avatar.layer.masksToBounds = true
        avatar.image = #imageLiteral(resourceName: "Personalicon")
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tblConversations.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if menuView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblConversations.frame.origin.x -= self.view.frame.width * 1.8 / 3
            })
        }
    }
    
    var mesIDList = [[String]]()
    var membersIDList = [[String]]()
    var membersImageData = [[Data]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupMenuView()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Conversations"
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "new_message_icon"), style: .plain, target: self, action: #selector(addConversationButtonDid)), animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(showProfileDid)), animated: true)

        
        tblConversations.register(UINib(nibName: "ConversarionTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        tblConversations.dataSource = self
        tblConversations.delegate = self
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            let name = user.displayName
            fullNameLabel.text = name!
            emailLabel.text = email!
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
                avatarImage.image = UIImage(data:data)
                print("Get Avatar Succeeded")
            }catch{
                print("Get Avatar Failed")
            }
            
            
            var count : Int = 0
            var friendCount : Int = 0
            
            ref.child("user-friends").child(currentUser.id).observe(.childAdded, with: { (snapshot) in
                friendCount += 1
                if friendCount == 1 {
                    self.friendCountLabel.text = "1 friend"
                }else {
                    self.friendCountLabel.text = "\(friendCount) friends"
                }
                
            })
            
            
            let tableID = ref.child("user-conversations").child(currentUser.id)
            tableID.observe(.childAdded, with: { (snapshot) in
                let conversationid = snapshot.value as! String
                let tableMembers = ref.child("conversations").child(conversationid).child("members")
                tableMembers.observe(.childAdded, with: { (snapshot2) in
                    DispatchQueue.main.async {
                        if count == 0 {
                            indexSS += 1
                            self.membersIDList.append(["startmember"])
                            self.mesIDList.append(["startmes"])
                            self.tblConversations.reloadData()
                        }
                        count += 1
                        if snapshot2.key != currentUser.id {
                            self.membersIDList[indexSS].append(snapshot2.key)
                        }
                    }
                })
                
                let tableMesID = ref.child("conversations").child(conversationid).child("messages")
                tableMesID.observe(.childAdded, with: { (snapshot3) in
                    DispatchQueue.main.async {
                        self.mesIDList[indexSS].append(snapshot3.key)
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
        navigationController?.pushViewController(NewConversationWithMultiplayer(), animated: true)
    }
    
    func setupMenuView() {
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        right.direction = .right
        view.addGestureRecognizer(right)
        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        left.direction = .left
        view.addGestureRecognizer(left)
        
        menuView = UIView(frame: CGRect(x: -view.frame.width * 1.8 / 3, y: 64, width: view.frame.width * 1.8 / 3, height: view.frame.height - 64 - 49))
        navigationController?.view.addSubview(menuView)
        view.addSubview(tblConversations)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0]-49-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : tblConversations]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : tblConversations]))
        
        
        menuView.backgroundColor = #colorLiteral(red: 0.8587385416, green: 0.8588830829, blue: 0.8587195277, alpha: 1)
        menuView.addSubview(profileLabel)
        menuView.addSubview(avatarImage)
        menuView.addSubview(fullNameLabel)
        menuView.addSubview(emailLabel)
        menuView.addSubview(friendCountLabel)
        menuView.addSubview(logoutButton)
        menuView.addSubview(devInforLabel)
        
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(40)]-10-[v1(140)]-10-[v2(40)][v3(25)]-10-[v4(15)]-15-[v5(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileLabel , "v1" : avatarImage, "v2" : fullNameLabel, "v3" : emailLabel, "v4" : friendCountLabel, "v5" : logoutButton]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : devInforLabel]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileLabel]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : fullNameLabel]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : emailLabel]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : friendCountLabel]))
        menuView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : devInforLabel]))
        avatarImage.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
        avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier: 2/5).isActive = true
        logoutButton.addTarget(self, action: #selector(logoutButtonDid), for: .touchUpInside)
    }
    
    func rightSwipe() {
        if menuView.frame.origin.x < 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.menuView.frame.origin.x += self.view.frame.width * 1.8 / 3
                self.tblConversations.frame.origin.x += self.view.frame.width * 1.8 / 3
            })
        }
    }
    
    func leftSwipe() {
        if menuView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblConversations.frame.origin.x -= self.view.frame.width * 1.8 / 3
            })
        }
    }
    
    func showProfileDid() {
        if menuView.frame.origin.x < 0 {
            UIView.animate(withDuration: 0.5) {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.menuView.frame.origin.x += self.view.frame.width * 1.8 / 3
                self.tblConversations.frame.origin.x += self.view.frame.width * 1.8 / 3
            }
        }else {
            UIView.animate(withDuration: 0.5) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblConversations.frame.origin.x -= self.view.frame.width * 1.8 / 3
            }
        }
        
    }
    
    func logoutButtonDid() {
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
        }
        if membersIDList[indexPath.row].count == 2 {
            ref.child("users").child(membersIDList[indexPath.row][1]).child("photoURL").observeSingleEvent(of: .value, with: { (snapshot) in
                let photoURL = snapshot.value as! String
                cell.imgAvatar.loadAvatar(link: photoURL)
            }) { (error) in
                print(error.localizedDescription)
            }
        }else if membersIDList[indexPath.row].count > 2 {
            cell.imgAvatar.image = #imageLiteral(resourceName: "friendicon")
            cell.imgAvatar.layer.borderWidth = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSS = indexPath.row
        let layout = UICollectionViewFlowLayout()
        let controller = ChatViewForListConversations(collectionViewLayout: layout)
        controller.membersIDList = membersIDList[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
