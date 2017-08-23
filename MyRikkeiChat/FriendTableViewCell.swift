//
//  FriendTableViewCell.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/18/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgAvatar.layer.cornerRadius = 25
        imgAvatar.layer.borderColor = UIColor.black.cgColor
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
