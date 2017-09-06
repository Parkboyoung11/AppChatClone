//
//  ListFriendViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/18/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

var visitor:User!

class ListFriendViewController: UIViewController {
    
    var listFriends = [User]()
    
    let searchBarFriends : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Friends"
        return searchBar
    }()
    
    let tblFriends : UITableView = {
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
    
    let dimView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if menuView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.searchBarFriends.isUserInteractionEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblFriends.frame.origin.x -= self.view.frame.width * 1.8 / 3
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Friends"
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addFriendButtonDid)), animated: true)
        navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: #selector(showProfileDid)), animated: true)
        
        tblFriends.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        tblFriends.dataSource = self
        tblFriends.delegate = self
        searchBarFriends.delegate = self
        var friendCount : Int = 0
        
        let tableID = ref.child("user-friends").child(currentUser.id)
        tableID.observe(.childAdded, with: { (snapshot) in
            friendCount += 1
            if friendCount == 1 {
                self.friendCountLabel.text = "1 friend"
            }else {
                self.friendCountLabel.text = "\(friendCount) friends"
            }
            let friendID = snapshot.key
            ref.child("users").child(friendID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let email = value?["email"] as? String ?? ""
                let fullName = value?["fullName"] as? String ?? ""
                let photoURL = value?["photoURL"] as? String ?? ""
                let user:User = User(id: friendID, email: email, fullName: fullName, photoURL: photoURL)
                self.listFriends.append(user)
                DispatchQueue.main.async {
                    self.tblFriends.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }
    
    func addFriendButtonDid() {
        navigationController?.pushViewController(AddFriendViewController(), animated: true)
        searchBarFriends.resignFirstResponder()
    }
    
    func setupMenuView() {
        fullNameLabel.text = currentUser.fullName
        emailLabel.text = currentUser.email
        avatarImage.image = currentUser.avatar
        
        view.addSubview(searchBarFriends)
        view.addSubview(tblFriends)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[v0(44)][v1]-49-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : searchBarFriends, "v1" : tblFriends]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : searchBarFriends]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1" : tblFriends]))
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        right.direction = .right
        view.addGestureRecognizer(right)
        let left = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        left.direction = .left
        view.addGestureRecognizer(left)
        
        view.addSubview(dimView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-108-[v0]-49-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dimView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : dimView]))
        dimView.isHidden = true
        
        menuView = UIView(frame: CGRect(x: -view.frame.width * 1.8 / 3, y: 64 + 44, width: view.frame.width * 1.8 / 3, height: view.frame.height - 64 - 49 - 44))
        navigationController?.view.addSubview(menuView)
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
                self.searchBarFriends.isUserInteractionEnabled = false
                self.menuView.frame.origin.x += self.view.frame.width * 1.8 / 3
                self.tblFriends.frame.origin.x += self.view.frame.width * 1.8 / 3
            })
        }
    }
    
    func leftSwipe() {
        if menuView.frame.origin.x == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.searchBarFriends.isUserInteractionEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblFriends.frame.origin.x -= self.view.frame.width * 1.8 / 3
            })
        }
    }
    
    func showProfileDid() {
        if menuView.frame.origin.x < 0 {
            UIView.animate(withDuration: 0.5) {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.searchBarFriends.isUserInteractionEnabled = false
                self.menuView.frame.origin.x += self.view.frame.width * 1.8 / 3
                self.tblFriends.frame.origin.x += self.view.frame.width * 1.8 / 3
            }
        }else {
            UIView.animate(withDuration: 0.5) {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.searchBarFriends.isUserInteractionEnabled = true
                self.menuView.frame.origin.x -= self.view.frame.width * 1.8 / 3
                self.tblFriends.frame.origin.x -= self.view.frame.width * 1.8 / 3
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
    
    func hideKeyboardss() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardss))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardss() {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        dimView.isHidden = true
        searchBarFriends.showsCancelButton = false
        searchBarFriends.resignFirstResponder()
    }

}

extension ListFriendViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! FriendTableViewCell
        cell.lblName.text = listFriends[indexPath.row].fullName
        cell.imgAvatar.loadAvatar(link: listFriends[indexPath.row].photoURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSS = indexPath.row
        let layout = UICollectionViewFlowLayout()
        let controller = ChatCollectionViewController(collectionViewLayout: layout)
        visitor = listFriends[indexPath.row]
        let url = URL(string: visitor.photoURL)
        do{
            let data = try Data(contentsOf: url!)
            visitor.avatar = UIImage(data: data)
        }catch {
            visitor.avatar = UIImage(named: "Personalicon")
            print("Load Avatar Visitor Error")
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ListFriendViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        dimView.isHidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        dimView.isHidden = false
        searchBar.showsCancelButton = true
        hideKeyboardss()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        dimView.isHidden = true
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
