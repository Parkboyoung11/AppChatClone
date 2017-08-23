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
    @IBOutlet weak var searchBarFriends: UISearchBar!
    @IBOutlet weak var tblFriends: UITableView!
    
    var listFriends = [User]()
    
    init() {
        super.init(nibName: "ListFriendViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Friends"
        tblFriends.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        tblFriends.dataSource = self
        tblFriends.delegate = self
        
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
                    self.tblFriends.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        })
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
        let layout = UICollectionViewFlowLayout()
        let controller = ChatCollectionViewController(collectionViewLayout: layout)
        controller.friendName = listFriends[indexPath.row].fullName
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
