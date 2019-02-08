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
        
        DispatchQueue.global().async {
            //print("请求线程,\(Thread.current),请求参数:\(String(describing: params))")
            
            //成功回调
            let successBlock  = {(task:URLSessionDataTask, result : Any) in
                DispatchQueue.main.async {
                    complete(result, nil)
                    //print("返回线程,\(Thread.current),返回结果:\(result)")
                }
            }
            
            //失败回调
            let failureBlock  = {(task:URLSessionDataTask?, error :Error) in
                DispatchQueue.main.async {
                    complete(nil, error)
                    //print("返回线程,\(Thread.current),失败结果:\(error)")
                }
            }
            
            //区分GET、POSt请求
            if method == .GET{
                self.get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
            }else{
                self.post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
            }
        }
    }
}
