//
//  AddFriendViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/23/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController {
    
    var isSearching = false
    var filterDataEmail = [String]()
    var filterDataName = [String]()
    var dataEmail = [String]()
    var dataName = [String]()
    var dataPhotoURL = [String]()
    var dataNameClone = [String]()
    var friendListID = [String]()
    var dataNotFriendID = [String]()
    
    let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Find friend with email"
        return searchBar
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func setupView(){
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0(44)][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : searchBar, "v1" : tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : tableView]))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find Friends"
        tabBarController?.tabBar.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        setupView()
        tableView.register(AddFriendTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        ref.child("user-friends").child(currentUser.id).observe(.childAdded, with: { (snapshot4) in
            self.friendListID.append(snapshot4.key)
        })
        
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            var lock = 1
            for i in 0..<self.friendListID.count {
                if snapshot.key == self.friendListID[i]{
                    lock = 0
                    break
                }
            }
            if snapshot.key == currentUser.id || lock == 0 {
                
            }else {
                let postDict = snapshot.value as? [String: String]
                if postDict != nil {
                    let email = (postDict?["email"])
                    self.dataEmail.append(email!)
                }
            }
            
        })
        
        ref.child("users").observe(.childAdded, with: { (snapshot2) in
            var lock = 1
            for i in 0..<self.friendListID.count {
                if snapshot2.key == self.friendListID[i]{
                    lock = 0
                    break
                }
            }
            if snapshot2.key == currentUser.id || lock == 0 {
                
            }else {
                let postDict = snapshot2.value as? [String: String]
                if postDict != nil {
                    let name = (postDict?["fullName"])
                    self.dataName.append(name!)
                    self.dataNameClone.append(name!)
                }
            }
            
        })
        
        ref.child("users").observe(.childAdded, with: { (snapshot3) in
            var lock = 1
            for i in 0..<self.friendListID.count {
                if snapshot3.key == self.friendListID[i]{
                    lock = 0
                    break
                }
            }
            if snapshot3.key == currentUser.id || lock == 0 {
                
            }else {
                let postDict = snapshot3.value as? [String: String]
                if postDict != nil {
                    let url = (postDict?["photoURL"])
                    self.dataPhotoURL.append(url!)
                    print(self.dataPhotoURL)
                }
            }
        })
        
        ref.child("users").observe(.childAdded, with: { (snapshot4) in
            var lock = 1
            for i in 0..<self.friendListID.count {
                if snapshot4.key == self.friendListID[i]{
                    lock = 0
                    break
                }
            }
            if snapshot4.key == currentUser.id || lock == 0 {
                
            }else {
                let postDict = snapshot4.value as? [String: String]
                if postDict != nil {
                    let uid = (postDict?["uid"])
                    self.dataNotFriendID.append(uid!)
                }
            }
        })
        
        
    }
    
    private var keyOfConversations : String = String()
    
    func addFriendButtonDid(sender : UIButton) {
        let index = sender.tag
        dataEmail.remove(at: index)
        dataName.remove(at: index)
        dataPhotoURL.remove(at: index)
        dataNameClone.remove(at: index)
        filterDataEmail = dataEmail.filter({$0 == searchBar.text})
        filterDataName = dataName.filter({$0 == searchBar.text})
        tableView.reloadData()
 
        ref.child("user-friends").child(currentUser.id).child(dataNotFriendID[index]).setValue("TRUE")
        ref.child("user-friends").child(dataNotFriendID[index]).child(currentUser.id).setValue("TRUE")
        
        let idFirebaseCurrent = ref.child("user-conversations").child(currentUser.id).child(dataNotFriendID[index])
        let idFirebaseVisitor = ref.child("user-conversations").child(dataNotFriendID[index]).child(currentUser.id)
        self.creatConversation( idss : dataNotFriendID[index])
        idFirebaseCurrent.setValue(self.keyOfConversations)
        idFirebaseVisitor.setValue(self.keyOfConversations)
        dataNotFriendID.remove(at: index)

    }
    
    func creatConversation(idss : String) {
        let user:Dictionary<String,String> = [currentUser.id : "TRUE", idss : "TRUE"]
        let randomID = ref.child("conversations").childByAutoId()
        keyOfConversations = randomID.key
        randomID.child("members").setValue(user)
    }


}

extension AddFriendViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterDataEmail.count != 0 {
            return filterDataEmail.count
        }
        if filterDataName.count != 0 {
            dataNameClone = dataName
            return filterDataName.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddFriendTableViewCell
        if isSearching {
            if !filterDataEmail.isEmpty {
                let string = filterDataEmail[indexPath.row]
                let index = dataEmail.index(of: string)
                cell.addButton.tag = index!
                cell.lblName.text = dataName[index!]
                cell.profileImageView.loadAvatar(link: dataPhotoURL[index!])
                cell.addButton.addTarget(self, action: #selector(addFriendButtonDid(sender:)), for: .touchUpInside)
            }else if !filterDataName.isEmpty {
                let string = filterDataName[indexPath.row]
                let index = dataNameClone.index(of: string)
                cell.addButton.tag = index!
                dataNameClone[index!] = "xxx"
                cell.lblName.text = string
                cell.profileImageView.loadAvatar(link: dataPhotoURL[index!])
                cell.addButton.addTarget(self, action: #selector(addFriendButtonDid(sender:)), for: .touchUpInside)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddFriendViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil {
            isSearching = false
            tableView.reloadData()
        } else {
            isSearching = true
            filterDataEmail = dataEmail.filter({$0 == searchBar.text})
            filterDataName = dataName.filter({$0 == searchBar.text})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

class AddFriendTableViewCell: UITableViewCell {
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

