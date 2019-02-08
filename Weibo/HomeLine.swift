//
//  HomeLine.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeLine: NSObject {
    
    /// 微博ID
    @objc var id:Int = 0
    /// 微博信息内容
    @objc var text:String?
    /// 微博创建时间
    @objc var created_at:String?
    /// 微博来源
    @objc var source:String?
    /// 缩略图数组
    @objc var pic_urls:[[String:String]]?
    /// 用户信息
    @objc var user:User?
    /// 转发微博信息
    @objc var retweeted_status:HomeLine?
    
    init(dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user"{
            if let dict = value as? [String:Any]{
                user = User(dict: dict)
            }
            return
        }
        if key == "retweeted_status"{
            if let dict = value as? [String:Any]{
                retweeted_status = HomeLine(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["id","text","created_at","source","user","pic_urls","retweeted_status"]).description
    }
}
