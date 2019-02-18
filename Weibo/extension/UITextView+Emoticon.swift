//
//  UITextView+Emoticon.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/15.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

extension UITextView{
    
    /// 发布图文混排
    var pushTextPic : String{
        var atrTemp = String()
        attributedText?.enumerateAttributes(in: NSRange(location: 0, length: attributedText?.length ?? 0), options: [], using: { (dict, range, _) in
            
            if let accachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment{
                atrTemp += accachment.emoticon.chs ?? ""
            }else{
                let str = ((attributedText?.string ?? "") as NSString).substring(with: range)
                atrTemp += str
            }
        })
        return atrTemp
    }
    
    /// 显示的图片混排
    func showTextPic(emoticon:Emoticon){
        // 空白表情
        if emoticon.isEmpty{
            return
        }
        // 删除按钮
        if emoticon.isRemove{
            deleteBackward()
            return
        }
        // emoji表情
        if let emoji = emoticon.code?.emoji{
            replace(selectedTextRange!, withText: emoji)
            return
        }
        // 普通表情
        self.insertImgEmoticon(emoticon: emoticon)
    }
    
    private func insertImgEmoticon(emoticon:Emoticon){
        // 图片的属性文本
        let attachment = EmoticonAttachment(emoticon: emoticon)
        attachment.image = UIImage(contentsOfFile: emoticon.imgPath)
        // 线高 表示字体的高度
        let lineHeight = font!.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: lineHeight, height: lineHeight)
        // 获得图片文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        imageText.addAttribute(NSAttributedString.Key.font, value:font!, range: NSRange(location: 0, length: 1))
        // 记录mTextView的attributedString 转成可变文本
        let textArr = NSMutableAttributedString(attributedString:attributedText)
        // 插入图片文本
        textArr.replaceCharacters(in:selectedRange, with: imageText)
        // 记录光标位置
        let range = selectedRange
        // 替换文本
       attributedText = textArr
        // 恢复光标位置
       selectedRange = NSRange(location: range.location+1, length: 0)
    }
}
