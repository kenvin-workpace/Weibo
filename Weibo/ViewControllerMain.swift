//
//  ViewControllerMain.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewControllerMain: UITabBarController {

    //撰写按钮
    lazy var profileBtn:UIButton = UIButton(iconName: "tabbar_compose_icon_add", backgroundIconName: "tabbar_compose_button")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建TabBarItem
        init_tabBarItem_childs()
        //添加TabBarItem撰写按钮
        init_tabBarItem_profile_btn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.bringSubviewToFront(profileBtn)
    }
}



// MARK:添加撰写按钮
extension ViewControllerMain{
    
    private func init_tabBarItem_profile_btn(){
        //添加
        tabBar.addSubview(profileBtn)
        //显示位置
        let count = viewControllers?.count
        let width = tabBar.bounds.width / CGFloat(count!) - 1
        profileBtn.frame = tabBar.bounds.insetBy(dx: 2*width, dy: 0)
        //添加点击事件
        profileBtn.addTarget(self, action: #selector(clickProfile), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func clickProfile() -> Void {
        print("菜单栏+号，被点击了")
    }
}

// MARK:添加视图控制器
extension ViewControllerMain{
    
    private func init_tabBarItem_childs() {
        addChild(vc: TableViewControllerHome(), title: "首页", imgName: "tabbar_home")
        addChild(vc: TableViewControllerMessage(), title: "消息", imgName: "tabbar_message_center")
        addChild(UIViewController())
        addChild(vc: TableViewControllerDiscover(), title: "发现", imgName: "tabbar_discover")
        addChild(vc: TableViewControllerMine(), title: "我的", imgName: "tabbar_mine")
    }
    
    private func addChild(vc:UIViewController,title:String,imgName:String) {
        //title
        vc.title = title
        //item图像
        vc.tabBarItem.image = UIImage(named: imgName)
        //导航控制器
        let nav = UINavigationController(rootViewController: vc)
        addChild(nav)
    }
}
