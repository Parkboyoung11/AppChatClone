//
//  ChatViewForListConversations.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/26/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//


import UIKit
import Firebase

class ChatViewForListConversations: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellIdd"
    var keyOfConversations : String = String()
    var lockScroll = 0
    var listMessage : [messageStruct] = [messageStruct](){
        didSet {
            lockScroll = 1
        }
    }
    var bottomConstraint : NSLayoutConstraint?
    var friendID = String()
    var arrIDChat : Array<String> = Array<String>()
    var membersIDList = [String]()
    
    let messageInputContainerView : UIView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersIDList.remove(at: 0)
        print(membersIDList)
        var membersName : String = ""
        for i in 0..<membersIDList.count {
            ref.child("users").child(membersIDList[i]).child("fullName").observeSingleEvent(of: .value, with: { (snapshot) in
                let memberName = snapshot.value as! String
                if membersName != "" {
                    membersName = membersName + ", " + memberName
                }else {
                    membersName = memberName
                }
                DispatchQueue.main.async {
                    print(membersName)
                    self.navigationItem.title = membersName
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        tabBarController?.tabBar.isHidden = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatLogVer2MessageCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(messageInputContainerView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageInputContainerView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(48)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : messageInputContainerView]))
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        inputTextField.myTextFieldSkin()
        inputTextField.delegate = self
        
        setupInputComponents()
        
        for i in 0..<membersIDList.count {
            arrIDChat.append(membersIDList[i])
        }
        
        arrIDChat.sort()
        
        var keyIDUser = String()
        
        for i in 0..<arrIDChat.count {
            keyIDUser = keyIDUser + arrIDChat[i]
        }
        
        ref.child("user-conversations").child(currentUser.id).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let conversationID = value?[keyIDUser] as? String ?? ""
            self.keyOfConversations = conversationID
            self.showConversationToView(id : conversationID)
        }) { (error) in
            print(error.localizedDescription)
            print("---------Error!-----------")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func showConversationToView(id : String) {
        ref.child("conversations").child(id).child("messages").observe(.childAdded, with: { (snapshot) in
            let messID = snapshot.key
            ref.child("messages").child(messID).observeSingleEvent(of: .value, with: { (snapshots) in
                let value = snapshots.value as? NSDictionary
                let fromID = value?["fromUID"] as? String ?? ""
                let mess = value?["content"] as? String ?? ""
                let mesStruct = messageStruct(fromUID: fromID, content: mess)
                self.listMessage.append(mesStruct)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
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
                    if self.listMessage.count > 0 {
                        let indexPath = IndexPath(item: self.listMessage.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    
    private func setupInputComponents(){
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
        sendButton.addTarget(self, action: #selector(sendButtonDid), for: .touchUpInside)
    }
    
    func sendButtonDid() {
        let mess : String = inputTextField.text!
        if mess != "" {
            inputTextField.endEditing(true)
            inputTextField.text = ""
            let messageNode = ref.child("messages").childByAutoId()
            let messageRandomID = messageNode.key
            let structMes : Dictionary<String,String> = ["fromUID": currentUser.id, "content": mess]
            messageNode.setValue(structMes)
            ref.child("conversations").child(keyOfConversations).child("messages").child(messageRandomID).setValue("TRUE")
        }else {
            print("Text Field have no text")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMessage.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogVer2MessageCell
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: listMessage[indexPath.row].content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        if lockScroll == 1 {
            let indexPaths = IndexPath(item: self.listMessage.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPaths, at: .bottom, animated: true)
            lockScroll = 0
        }
        
        if listMessage[indexPath.row].fromUID != currentUser.id {
            cell.messageTextView.text = listMessage[indexPath.row].content
            let idfriends = listMessage[indexPath.row].fromUID
            for i in 0..<membersIDList.count {
                if idfriends == membersIDList[i] {
                    ref.child("users").child(idfriends!).child("photoURL").observeSingleEvent(of: .value, with: { (snapshot) in
                        DispatchQueue.main.async {
                            cell.profileImageView.loadAvatar(link: (snapshot.value as? String)!)
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    break
                }
            }
            cell.profileImageView.isHidden = false
            cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.messageTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            cell.messageTextView.text = listMessage[indexPath.row].content
            cell.profileImageView.isHidden = true
            cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 32, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 40, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.messageTextView.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: listMessage[indexPath.row].content).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        //        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
}

class ChatLogVer2MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImageView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}

extension ChatViewForListConversations: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
