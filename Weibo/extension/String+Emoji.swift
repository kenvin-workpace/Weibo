//
//  String+Emoji.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

extension String {
    
    /// unicode 转 emoji表情
    var emoji:String{
        // 扫描器-扫描指定文本
        let scanner = Scanner(string: self)
        // unicode
        var value:UInt32 = 0
        scanner.scanHexInt32(&value)
        // 转换unicode字符
        let chr = Character(Unicode.Scalar(value)!)
        return "\(chr)"
    }
}
