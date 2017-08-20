//
//  CheckExtensionss.swift
//  MyRikkeiChat
//
//  Created by VuHongSon on 8/16/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func checkEmail(mail: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: mail)
    }
}
