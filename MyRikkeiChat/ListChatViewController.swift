//
//  ListChatViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/17/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit
import Firebase

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
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "Conversations"
        //tblConversations.register(ConversarionTableViewCell.self, forCellReuseIdentifier: "cellID")
        tblConversations.register(UINib(nibName: "ConversarionTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        tblConversations.dataSource = self
        tblConversations.delegate = self
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
