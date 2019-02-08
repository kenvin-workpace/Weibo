//
//  User.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class User: NSObject {

    /// 用户UID
    @objc var id:Int = 0
    /// 用户昵称
    @objc var screen_name:String?
    /// 用户头像地址 (中图),50*50像素
    @objc var profile_image_url:String?
    /// 认证类型，-1:没有认证，0：认证用户，2，3，5:企业认证，220:达人
    @objc var verified_type:Int = 0
    /// 会员等级0～6
    @objc var mbrank:Int = 0
   
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["id","screen_name","profile_image_url","verified_type","mbrank"]).description
    }
}
