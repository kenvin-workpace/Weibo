//
//  TokenInfoModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class TokenInfoModel {
    
    //单例
    static let shareInstance = TokenInfoModel()
    
    //用户模型
    var tokenInfo:TokenInfo?
    
    private init() {
        // 从存档取数据
        tokenInfo = getTokenFromPlist()
        //判断账号是否过期
        if isExpired {
            tokenInfo = nil
            print("账号过期")
        }
    }
    
}

extension TokenInfoModel{
    
    var isLoginStatus : Bool{
        return tokenInfo?.access_token != nil && !isExpired
    }
    
    ///判断账号是否过期
    var isExpired:Bool{
        //是否登录过
        guard let expire = tokenInfo?.expires_in else {
            return true
        }
        //是否过期
        if WeiboUtil.build.int2NSDate(time: expire).compare(Date()) == ComparisonResult.orderedDescending{
            return false
        }
        //过期返回true
        return true;
    }
    
    /// 从存档取数据
    func getTokenFromPlist() -> TokenInfo? {
        let url = NSURL(fileURLWithPath: WeiboUtil.build.path) as URL
        let data = try? Data(contentsOf: url)
        if data != nil {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [TokenInfo.classForKeyedUnarchiver()], from: data!) as! TokenInfo
        }else{
            print("account.plist is nil")
        }
        return nil
    }
}

extension TokenInfoModel{
    
    /// 获取accessToken
    func getAccessToken(code:String,callback:@escaping (_ isSuccess:Bool)->()) -> Void {
        WeiboNet.build.loadAccessToken(code: code) { (result, error) in
            if error != nil{
                print("ViewControllerOAuth,method:getAccessToken,error:\(String(describing: error))")
                callback(false)
                return
            }
            print("ViewControllerOAuth,method:getAccessToken,result:\(String(describing: result))")
            let info = TokenInfo(dict: result as! [String : Any])
            // 获取 user show
            self.loadUserShow(tokenInfo: info,complete: callback )
        }
    }
    
    /// 获取 user show
    func loadUserShow(tokenInfo:TokenInfo,complete:@escaping (_ isSuccess:Bool)->()) -> Void {
        WeiboNet.build.loadUseShow(token: tokenInfo.access_token!, uid: tokenInfo.uid!) { (result, error) in
            if error != nil{
                print("ViewControllerOAuth,method:loadUserShow,error:\(String(describing: error))")
                complete(false)
                return
            }
            guard let dict = result as? [String:Any] else{
                print("ViewControllerOAuth,method:loadUserShow,error: guard let dict = result 转换失败")
                complete(false)
                return
            }
            tokenInfo.screen_name = dict["screen_name"] as? String
            tokenInfo.avatar_large = dict["avatar_large"] as? String
            //存档
            tokenInfo.saveAccount()
            //成功标志
            complete(true)
        }
    }
}
