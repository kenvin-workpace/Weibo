//
//  HttpUtil.swift
//  Weibo
//
//  Created by Kevin on 2019/2/3.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import AFNetworking

enum HttpMethod : String{
    case GET = "GET"
    case POST = "POST"
}

class HttpUtil: AFHTTPSessionManager {
    //单例
    static let shareInstance:HttpUtil = {
        let instance = HttpUtil()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
}

// MARK: 封装网络请求
extension HttpUtil{
    
    func request(method : HttpMethod, url : String, params : [String : Any]?, complete :@escaping (_ result : Any?, _ error : Error?)->()){
        print("request,params=\(String(describing: params))")
        //成功回调
        let successBlock  = {(task:URLSessionDataTask, result : Any) in
            complete(result, nil)
        }
        
        //失败回调
        let failureBlock  = {(task:URLSessionDataTask?, error :Error) in
             complete(nil, error)
        }
        
        //区分GET、POSt请求
        if method == .GET{
            self.get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }else  {
            self.post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    
    func upload(url : String, params : [String : Any]?,data: Data, name: String, complete :@escaping (_ result : Any?, _ error : Error?)->()){
        //成功回调
        let successBlock  = {(task:URLSessionDataTask, result : Any) in
            complete(result, nil)
        }
        
        //失败回调
        let failureBlock  = {(task:URLSessionDataTask?, error :Error) in
            complete(nil, error)
        }
        
        post(url, parameters: params, constructingBodyWith: { (formdata) in
            formdata.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            
        }, progress: nil, success: successBlock, failure: failureBlock)
    }
}
