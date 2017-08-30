//
//  NewConversationWithMultiplayer.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/29/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//


import UIKit
import Firebase

class NewConversationWithMultiplayer: UIViewController {
    
    var listFriends = [User]()
    var listFriendsInConversation = [String]()
    var keyOfConversations : String = String()
    var bottomConstraint : NSLayoutConstraint?
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let toLabel : UILabel = {
        let label = UILabel()
        label.text = "to"
        label.textColor = #colorLiteral(red: 1, green: 0.06543179506, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let receiverLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageInputContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let toContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Enter Message...."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0368008456, green: 0.08081357971, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupView(){
        view.addSubview(messageInputContainerView)
        view.addSubview(tableView)
        view.addSubview(toContainerView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0(60)][v1][v2(49)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : toContainerView, "v1" : tableView, "v2" : messageInputContainerView]))

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : toContainerView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2" : messageInputContainerView]))
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)

        let bottomBorderToView = UIView()
        bottomBorderToView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bottomBorderToView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelBorderView = UIView()
        labelBorderView.backgroundColor = UIColor.clear
        labelBorderView.layer.borderWidth = 1
        labelBorderView.layer.borderColor = UIColor.black.cgColor
        labelBorderView.layer.cornerRadius = 7
        labelBorderView.layer.masksToBounds = true
        labelBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        
        toContainerView.addSubview(toLabel)
        toContainerView.addSubview(bottomBorderToView)
        toContainerView.addSubview(labelBorderView)
        
        toContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : toLabel]))
        
        toContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : bottomBorderToView]))
        
        toContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v1]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : labelBorderView]))
        
        toContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2" : bottomBorderToView]))
        
        toContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(20)]-10-[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : toLabel, "v1" : labelBorderView]))
        
        labelBorderView.addSubview(receiverLabel)
        labelBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : receiverLabel]))
        labelBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : receiverLabel]))
        
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        let textFieldBorderView = UIView()
        textFieldBorderView.backgroundColor = UIColor.clear
        textFieldBorderView.layer.borderWidth = 1
        textFieldBorderView.layer.borderColor = UIColor.brown.cgColor
        textFieldBorderView.layer.cornerRadius = 5
        textFieldBorderView.layer.masksToBounds = true
        textFieldBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputContainerView.addSubview(textFieldBorderView)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        textFieldBorderView.addSubview(inputTextField)
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0][v1(60)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : textFieldBorderView, "v1" : sendButton]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : textFieldBorderView]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : sendButton]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2" : topBorderView]))
        messageInputContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v2(0.5)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2" : topBorderView]))
        textFieldBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v3]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3" : inputTextField]))
        textFieldBorderView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3" : inputTextField]))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "New Conversation"
        listFriendsInConversation.append(currentUser.id)
        
        
        setupView()
        sendButton.addTarget(self, action: #selector(sendButtonDid(sender:)), for: .touchUpInside)
        tableView.register(NewConversationWithMultiplayerCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.myTextFieldSkin()
        inputTextField.delegate = self
        
        let tableID = ref.child("user-friends").child(currentUser.id)
        tableID.observe(.childAdded, with: { (snapshot) in
            let friendID = snapshot.key
            ref.child("users").child(friendID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let email = value?["email"] as? String ?? ""
                let fullName = value?["fullName"] as? String ?? ""
                let photoURL = value?["photoURL"] as? String ?? ""
                let user:User = User(id: friendID, email: email, fullName: fullName, photoURL: photoURL)
                self.listFriends.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handKeyboardNotification(notification : NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShow = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShow ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShow {
//                    if self.listMessage.count > 0 {
//                        let indexPath = IndexPath(item: self.listMessage.count - 1, section: 0)
//                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
//                    }
                }
            })
        }
    }
    
    func addFriendButtonDid(sender : UIButton) {
        let index = sender.tag
        if receiverLabel.text == "" {
            receiverLabel.text = listFriends[index].fullName
            listFriendsInConversation.append(listFriends[index].id)
        }else {
            receiverLabel.text = receiverLabel.text! + ", " + listFriends[index].fullName
            listFriendsInConversation.append(listFriends[index].id)
        }
        
        listFriends.remove(at: index)
        tableView.reloadData()
    }
    
    func sendButtonDid(sender : UIButton) {
        if listFriendsInConversation.count < 3 {
            let noti = UIAlertController(title: "Warning", message: "Please add more than 2 friends to creat new conversation!", preferredStyle: .alert)
            let btn = UIAlertAction(title: "OK", style: .default, handler: nil)
            noti.addAction(btn)
            present(noti, animated: true, completion: nil)
        }else {
            let mess : String = inputTextField.text!
            if mess != "" {
                inputTextField.endEditing(true)
                inputTextField.text = ""
                self.creatConversation()
                for i in 0..<listFriendsInConversation.count {
                    var listFriendsClone = listFriendsInConversation
                    listFriendsClone.remove(at: i)
                    listFriendsClone.sort()
                    var idArray : String = ""
                    for j in 0..<listFriendsClone.count {
                        idArray += listFriendsClone[j]
                    }
                    ref.child("user-conversations").child(listFriendsInConversation[i]).child(idArray).setValue(self.keyOfConversations)
                }
                
                let messageNode = ref.child("messages").childByAutoId()
                let messageRandomID = messageNode.key
                let structMes : Dictionary<String,String> = ["fromUID": currentUser.id, "content": mess]
                messageNode.setValue(structMes)
                ref.child("conversations").child(keyOfConversations).child("messages").child(messageRandomID).setValue("TRUE")
                navigationController?.popViewController(animated: true)
                
            }else {
                print("Text Field have no text")
            }
        }
    }
    
    func creatConversation() {
        var user:Dictionary<String,String> = [currentUser.id : "TRUE"]
        for i in 1..<listFriendsInConversation.count {
            user.updateValue("TRUE", forKey: listFriendsInConversation[i])
        }
        let randomID = ref.child("conversations").childByAutoId()
        keyOfConversations = randomID.key
        randomID.child("members").setValue(user)
    }

    
}

extension NewConversationWithMultiplayer : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewConversationWithMultiplayerCell
        cell.lblName.text = listFriends[indexPath.row].fullName
        cell.profileImageView.loadAvatar(link: listFriends[indexPath.row].photoURL)
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addFriendButtonDid(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

class NewConversationWithMultiplayerCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(lblName)
        addSubview(addButton)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[v0(40)]-20-[v1]-5-[v2(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView, "v1" : lblName , "v2" : addButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v1]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : lblName]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2" : addButton]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let lblName : UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .left
        name.numberOfLines = 1
        name.text = "Ahihi"
        name.textColor = UIColor.black
        name.font = UIFont.systemFont(ofSize: 22)
        return name
    }()
    
    let addButton : UIButton = {
        let button = UIButton(type: UIButtonType.contactAdd)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "Personalicon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
}

extension NewConversationWithMultiplayer: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
