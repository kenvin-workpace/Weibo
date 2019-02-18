//
//  CommonUtil.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

/// 橘色
let COMMON_COLOR_ORANGE:UIColor = UIColor.orange

/// 通知对象
let CUSTOM_SWITCH_NOTIFICATIONCENTER = NSNotification.Name(rawValue: "CUSTOM_SWITCH_NOTIFICATIONCENTER")

class CommonUtil {
    
    static let shareInstance = CommonUtil()
    
    /// statusbar height + navigationbar height
    func getStatusNavBarHeight(nav:UINavigationController?)->CGFloat{
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = nav?.navigationBar.frame.height ?? 0
        let height = navHeight + statusBarHeight
        return height
    }
}
