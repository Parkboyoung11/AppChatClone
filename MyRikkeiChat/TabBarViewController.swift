//
//  TabBarViewController.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/17/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var listChatView: UITabBarItem!
    @IBOutlet weak var listFriendView: UITabBarItem!
    @IBOutlet weak var informationView: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        let listChatNV = creatTabBarView(systemItem: UITabBarSystemItem.recents, rootView: ListChatViewController())
        let listFriendNV = creatTabBarView(systemItem: UITabBarSystemItem.contacts, rootView: ListFriendViewController())
        let moreNV = creatTabBarView(systemItem: UITabBarSystemItem.more, rootView: MoreViewController())
        
        viewControllers = [listChatNV, listFriendNV, moreNV]
        print(1)
    }
    
    func creatTabBarView(systemItem : UITabBarSystemItem, rootView: UIViewController) -> UINavigationController {
        let viewNV = UINavigationController(rootViewController: rootView)
        viewNV.tabBarItem = UITabBarItem(tabBarSystemItem: systemItem, tag: 0)
        return viewNV
    }

}
