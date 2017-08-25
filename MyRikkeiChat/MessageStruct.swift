//
//  MessageStruct.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/23/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import Foundation
import UIKit
struct messageStruct {
    let fromUID:String!
    let content:String!
    
    init() {
        fromUID = ""
        content = ""
    }
    
    init(fromUID: String , content: String) {
        self.fromUID = fromUID
        self.content = content
    }
}
