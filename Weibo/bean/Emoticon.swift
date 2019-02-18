//
//  emoticon.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/11.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class Emoticon: NSObject {
    /// 发给服务端
    @objc var chs:String?
    /// 客户端显示
    @objc var png:String?
    /// emoji表情
    @objc var code:String?
    
    /// 表情的完整路径
    var imgPath:String{
        if png == nil{
            return ""
        }
        return Bundle.main.bundlePath+"/Emoticons.bundle/"+png!
    }
    
    /// 是否删除标记
    @objc var isRemove = false
    init(isRemove:Bool) {
        self.isRemove = isRemove
    }
    
    /// 是否空白标记
    @objc var isEmpty = false
    init(isEmpty:Bool) {
        self.isEmpty = isEmpty
    }
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["chs","png","code","isRemove","isEmpty"]).description
    }
}
