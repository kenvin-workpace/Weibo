//
//  TokenInfo.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class TokenInfo: NSObject,NSCoding,NSSecureCoding{
    
    static var supportsSecureCoding: Bool = true
    
    //acess token 返回信息
    @objc var access_token:String?
    @objc var uid:String?
    @objc var expires_in:Int = 0
    @objc var screen_name:String?
    @objc var avatar_large:String?
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // 存档
    func saveAccount() -> Void {
        let data =  try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        let url = NSURL(fileURLWithPath: WeiboUtil.build.path) as URL
        try? data?.write(to: url)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(access_token, forKey: "access_token")
    }
    
    required init?(coder aDecoder: NSCoder) {
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_in = aDecoder.decodeInteger(forKey: "expires_in")
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["access_token","expires_in","uid","expiresDate"]).description
    }
}
