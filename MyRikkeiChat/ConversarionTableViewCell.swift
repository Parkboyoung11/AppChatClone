//
//  ConversarionTableViewCell.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/18/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit

class ConversarionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblChat: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = 34
        imgAvatar.layer.borderColor = UIColor.blue.cgColor
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.masksToBounds = true
        imgAvatar.image = #imageLiteral(resourceName: "Personalicon")
        lblName.text = "haha"
        lblChat.text = "hehe"
    }
    
    
}
