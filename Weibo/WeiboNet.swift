//
//  WeiboNet.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class WeiboNet {
    
    // app key 潮流微博
    //private let appKey = "2266202231"
    
    // app key 备用微博
    private let appKey = "46721359"
    
    // redirect uri
    private let redirectUri = "http://www.baidu.com"
    
    // app secret 备用微博
    //private let appSecret = "e7152dcd22205fa131ff807096f82d00"
    
    private let appSecret = "dbb954309eee35e8098de7c3e1d0f8ae"
    
    //单例
    static let shareInstance = WeiboNet()
    
    private init() {
        
    }
    
    // 获取access token
    func getAccessToken() -> String {
        return AccountInfoViewModel.shareInstance.account?.access_token ?? ""
    }
}

// MARK: 用户方法
extension WeiboNet{
    
    /// 获取 home timeline
    /// [https://open.weibo.com/wiki/2/statuses/home_timeline](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func homeTimeLine(callback:@escaping (_ result:Any?)->()) -> Void {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        let param = ["access_token":getAccessToken()]
        
        HttpUtil.shareInstance.request(method: .GET, url: url, params: param) { (result, error) in
            if error != nil {
                print("WeiboNet,method:homeTimeLine,error=\(String(describing: error))")
                return
            }
            callback(result)
        }
    }
    
    /// 获取 user show
    func loadUseShow(token:String,uid:String,callback:@escaping (_ result:Any?,_ error:Error?)->()) -> Void {
        let url = "https://api.weibo.com/2/users/show.json"
        let param = ["access_token":token,"uid":uid]
        
        HttpUtil.shareInstance.request(method: HttpMethod.GET, url: url, params: param, complete: { (result, error) in
            if error != nil{
                print("WeiboNet,method:loadUseShow,error=\(String(describing: error))")
                return
            }
            callback(result,error)
        })
    }
}

// MARK: OAUTH 授权
extension WeiboNet{
    
    /// 获取 code
    var oAuthUrl:URL {
        let url = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirectUri)"
        return NSURL(string: url)! as URL
    }
    
    /// 获取 access token
    func loadAccessToken(code:String,callback :@escaping (_ result : Any?, _ error : Error?)->()) -> Void {
        let url = "https://api.weibo.com/oauth2/access_token"
        
        let param = ["client_id":self.appKey,"client_secret":self.appSecret,"grant_type":"authorization_code","code":code,"redirect_uri":self.redirectUri]
        
        HttpUtil.shareInstance.request(method: HttpMethod.POST, url: url, params: param, complete: { (result, error) in
            if error != nil{
                print("WeiboNet,method:loadAccessToken,error=\(String(describing: error))")
                return
            }
            callback(result,error)
        })
    }
}
