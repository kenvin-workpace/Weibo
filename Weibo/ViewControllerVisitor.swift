//
//  ViewControllerVisitor.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewControllerVisitor: UITableViewController {
    
    var isVisitor:Bool = TokenInfoModel.shareInstance.isLoginStatus
    
    var visitorView:UIViewVisitor?
    
    override func viewDidLoad() {
        isVisitor ? super.viewDidLoad() : useVisitorVc()
    }
    
    @objc private func useVisitorVc() -> Void {
        visitorView = UIViewVisitor()
        //设置代理
        visitorView?.delegate = self
        view = visitorView
        
        //设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(clickRegBtn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(clickLoginBtn))
    }
}

// 注册、按钮代理方法
extension ViewControllerVisitor : UIViewVisitorDelegate{
    
    /// 注册按钮
    @objc func clickRegBtn() {
        print("clickRegBtn")
    }
    
    /// 登录按钮
    @objc func clickLoginBtn() {
        let vc = ViewControllerOAuth()
        //添加导航栏
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}
