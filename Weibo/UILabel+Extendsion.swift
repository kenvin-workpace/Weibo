//
//  UILabel+Extendsion.swift
//  Weibo
//
//  Created by Kevin on 2019/2/3.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(title:String,color:UIColor = UIColor.darkGray,fontSize:CGFloat = 14) {
        self.init()
        
        text = title
        textColor = color
        numberOfLines = 0
        textAlignment = NSTextAlignment.center
        font = UIFont.systemFont(ofSize: fontSize)
    }
}
