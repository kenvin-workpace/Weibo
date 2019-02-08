//
//  TokenInfoModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class AccountInfoViewModel {
    
    //单例
    static let shareInstance = AccountInfoViewModel()
    
    //用户模型
    var account:AccountInfo?
    
    private init() {
        // 从存档取数据
        account = getAccountFromPlist()
        //判断账号是否过期
        if isExpired {
            account = nil
        }
    }
    
}

extension AccountInfoViewModel{
    
    ///判断用户是否登录
    var isLoginStatus : Bool{
        return account?.access_token != nil && !isExpired
    }
    
    ///判断账号是否过期
    var isExpired:Bool{
        //是否登录过
        guard let expire = account?.expires_in else {
            return true
        }
        //是否过期
        if WeiboUtil.shareInstance.int2NSDate(time: expire).compare(Date()) == ComparisonResult.orderedDescending{
            return false
        }
        //过期返回true
        return true;
    }
    
    /// 获取用户头像
    var headPic:URL{
        return NSURL(string: account?.avatar_large ?? "")! as URL
    }
    
    /// 从存档取数据
    func getAccountFromPlist() -> AccountInfo? {
        let url = NSURL(fileURLWithPath: WeiboUtil.shareInstance.path) as URL
        let data = try? Data(contentsOf: url)
        if data != nil {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [AccountInfo.classForKeyedUnarchiver()], from: data!) as! AccountInfo
        }else{
            print("account.plist is nil")
        }
        return nil
    }
}

extension AccountInfoViewModel{
    
    /// 获取accessToken
    func getAccessToken(code:String,callback:@escaping (_ isSuccess:Bool)->()) -> Void {
        WeiboNet.shareInstance.loadAccessToken(code: code) { (result, error) in
            if error != nil{
                print("ViewControllerOAuth,method:getAccessToken,error:\(String(describing: error))")
                callback(false)
                return
            }
            print("ViewControllerOAuth,method:getAccessToken,result:\(String(describing: result))")
            self.account = AccountInfo(dict: result as! [String : Any])
            // 获取 user show
            self.loadUserShow(tokenInfo: self.account!,complete: callback )
        }
    }
    
    /// 获取 user show
    func loadUserShow(tokenInfo:AccountInfo,complete:@escaping (_ isSuccess:Bool)->()) -> Void {
        WeiboNet.shareInstance.loadUseShow(token: tokenInfo.access_token!, uid: tokenInfo.uid!) { (result, error) in
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
