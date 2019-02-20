//
//  AppDelegate.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        //设置颜色
        setTincColor()
        //创建window
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ViewControllerBrowsePic()
        window?.makeKeyAndVisible()
        /// 根据通知切换根视图
        switchVc()
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: CUSTOM_SWITCH_NOTIFICATIONCENTER, object: nil)
    }
}

extension AppDelegate{
    
    /// 根据通知切换根视图
    private func switchVc() -> Void {
        
        NotificationCenter.default.addObserver(forName: CUSTOM_SWITCH_NOTIFICATIONCENTER, object:nil, queue: OperationQueue.main) {[weak self] (notification) in
            let vc = notification.object != nil ? ViewControllerWelcome() : ViewControllerMain()
            self?.window?.rootViewController = vc
        }
    }
    
    /// 判断使用哪个VC
    var selectViewController:UIViewController{
        // 账号是否登录
        if AccountInfoViewModel.shareInstance.isLoginStatus {
            return isNewVersion ? CollectionViewControllerFeature() : ViewControllerWelcome()
        }
        return ViewControllerMain()
    }
    
    /// 判断是否有新版本
    var isNewVersion:Bool{
        //获取当前版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //获取偏好版本
        let saveVersion = "saveVersion"
        let oldVersion = UserDefaults.standard.double(forKey: saveVersion)
        //存储当前版本
        UserDefaults.standard.setValue(currentVersion, forKey: saveVersion)
        return  Double(currentVersion)! > oldVersion
    }
    
    /// tintColor 设置为橘色
    @objc private func setTincColor(){
        UITabBar.appearance().tintColor = COMMON_COLOR_ORANGE
        UINavigationBar.appearance().tintColor = COMMON_COLOR_ORANGE
    }
}

