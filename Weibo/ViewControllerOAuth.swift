//
//  ViewControllerOAuth.swift
//  Weibo
//
//  Created by Kevin on 2019/2/3.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import WebKit

class ViewControllerOAuth: UIViewController {
    
    private lazy var webView = WKWebView()
    
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_view_setting()
        init_view_loading()
    }
}

// MARK: 加载View控件
extension ViewControllerOAuth : WKNavigationDelegate{
    
    func init_view_loading(){
        webView.load(URLRequest(url: WeiboNet.build.oAuthUrl))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("url__"+String(describing: webView.url?.host)+"___"+String(describing: webView.url?.query))
        let url = webView.url
        let baidu = "baidu.com"
        let failure = "error_uri"
        let success = "code="
        
        //是否是微博授权URL
        if url?.host?.hasSuffix(baidu) ?? false,url?.query?.hasPrefix(success) ?? false {
            //截取code
            let result = url?.query
            let key = result!.firstIndex(of: "&")
            var code:String = ""
            if key==nil{
                code = String(result![success.endIndex..<result!.endIndex])
            }else{
                code = String(result![success.endIndex..<key!])
            }
            print("<< code >>,\(code)")
            decisionHandler(WKNavigationResponsePolicy.cancel)
            //获取accessToken
            TokenInfoModel.shareInstance.getAccessToken(code: code) { (iSuccess) in
                iSuccess ? print("获取成功") : print("获取成功")
            }
            return
        }
        //允许跳转
        decisionHandler(WKNavigationResponsePolicy.allow)
        //授权取消，返回未登录界面
        if url?.host==baidu,url?.query?.hasPrefix(failure) ?? false{
            dismiss(animated: true, completion: nil)
            return
        }
    }
}

// MARK: OAUTH 页面基本设置
extension ViewControllerOAuth{
    
    private func init_view_setting(){
        //标题
        title = "授权登录"
        //设置为白色，优化效率
        view.backgroundColor = UIColor.white
        //添加关闭按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(clickClose))
        //添加自动填充按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(autoFillName))
    }
    
    @objc private func clickClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFillName(){
        webView.evaluateJavaScript("document.getElementById('userId').value='1337226928@qq.com';", completionHandler: nil)
    }
}
