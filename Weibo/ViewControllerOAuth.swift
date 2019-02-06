//
//  ViewControllerOAuth.swift
//  Weibo
//
//  Created by Kevin on 2019/2/3.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ViewControllerOAuth: UIViewController {
    
    private lazy var webView = WKWebView()
    
    let baidu = "baidu.com"
    let weibo = "weibo.com"
    let failure = "error_uri"
    let success = "code="
    
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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("url__"+String(describing: webView.url?.host)+"___"+String(describing: webView.url?.query))
        let url = webView.url
        
        //有微博域名，且重定向URL有百度
        if url?.host?.hasSuffix(weibo) ?? false {
            decisionHandler(WKNavigationResponsePolicy.allow)
            return
        }
        //授权成功
        if url?.host?.hasSuffix(baidu) ?? false,url?.query?.hasPrefix(success) ?? false{
            let code = getCode(url: url!)
            //获取accessToken
            AccountInfoModel.shareInstance.getAccessToken(code: code) { (iSuccess) in
                if !iSuccess{
                    SVProgressHUD.dismiss()
                    print("OAUTH 获取失败")
                    return
                }
                self.dismiss(animated: false, completion: {
                    NotificationCenter.default.post(name: CUSTOM_SWITCH_NOTIFICATIONCENTER, object: "welcome")
                })
            }
            SVProgressHUD.dismiss()
            decisionHandler(WKNavigationResponsePolicy.cancel)
            return
        }
        //授权失败
        if url?.host?.hasSuffix(weibo) ?? true,url?.query == nil{
            SVProgressHUD.showError(withStatus: "\n授权失败，请重试")
            decisionHandler(WKNavigationResponsePolicy.cancel)
            return
        }
        //取消授权
        if url?.host?.hasSuffix(baidu) == true,url?.query?.hasPrefix(failure) ?? true{
            decisionHandler(WKNavigationResponsePolicy.cancel)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(1*NSEC_PER_SEC))) {
                self.clickClose()
            }
            return
        }
    }
    
    func getCode(url:URL) -> String {
        let result = url.query
        let key = result!.firstIndex(of: "&")
        var code:String = ""
        if key==nil{
            code = String(result![success.endIndex..<result!.endIndex])
        }else{
            code = String(result![success.endIndex..<key!])
        }
        return code
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
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFillName(){
        webView.evaluateJavaScript("document.getElementById('userId').value='1337226928@qq.com';", completionHandler: nil)
    }
}
