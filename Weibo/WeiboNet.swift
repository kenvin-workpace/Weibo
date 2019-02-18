//
//  WeiboNet.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class WeiboNet {
    
    // app key 潮流微博
    private let appKey = "2266202231"
    
    // app key 备用微博
//    private let appKey = "46721359"
    
    // redirect uri
    private let redirectUri = "http://www.baidu.com"
    
    // app secret 备用微博
    private let appSecret = "e7152dcd22205fa131ff807096f82d00"
    
//    private let appSecret = "dbb954309eee35e8098de7c3e1d0f8ae"
    
    
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
    
    /// 获取 发布微博
    func sendStatus(status:String,img:UIImage?,callback: @escaping (_ result:Any?)->()){
        var param = [String:Any]()
        param["status"] = status
        param["access_token"] = getAccessToken()
        if img == nil {
            let url = "https://api.weibo.com/2/statuses/share.json"
            HttpUtil.shareInstance.request(method: .POST, url: url, params: param) { (result, error) in
                if error != nil {
                    print("WeiboNet,method:sendStatus,error=\(String(describing: error))")
                    return
                }
                callback(result)
            }
        }else{
            let url = "https://upload.api.weibo.com/2/statuses/upload.json"
            let data = img!.pngData()
            
            HttpUtil.shareInstance.upload(url: url, params: param, data: data!, name: "ff") { (result, error) in
                if error != nil {
                    print("WeiboNet,method:sendStatus,error=\(String(describing: error))")
                    return
                }
                callback(result)
            }
        }
    }
    
    
    /// 获取 home timeline
    /// [https://open.weibo.com/wiki/2/statuses/home_timeline](https://open.weibo.com/wiki/2/statuses/home_timeline)
    func homeTimeLine(since_id:Int,max_id:Int, callback:@escaping (_ result:Any?)->()) -> Void {
        let url = "https://api.weibo.com/2/statuses/home_timeline.json"
        var param:[String:Any] = ["access_token":getAccessToken()]
        
        if since_id > 0{
            // 下拉刷新数据
            param["since_id"] = since_id
        }else if max_id > 0{
            // 上拉刷新数据
            param["max_id"] = max_id - 1
        }
        
        HttpUtil.shareInstance.request(method: .GET, url: url, params: param) { (result, error) in
            if error != nil {
                //print("WeiboNet,method:homeTimeLine,error=\(String(describing: error))")
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
