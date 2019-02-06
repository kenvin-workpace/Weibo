//
//  WeiboUtil.swift
//  Weibo
//
//  Created by Kevin on 2019/2/4.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class WeiboUtil: NSObject {
    
    static let shareInstance = WeiboUtil()
    
    /// 路径
    var path:String{
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let result = (file as NSString).appendingPathComponent("account.plist")
        return result
    }
    
    /// int 转 NSDate
    func int2NSDate(time:Int) -> NSDate {
        let timeInterval = TimeInterval(exactly: time)
        let result = NSDate(timeIntervalSinceNow: timeInterval!);
        return result
    }
    
    /// 屏幕尺寸
    @objc func getScreenBounds() -> CGRect{
        return UIScreen.main.bounds
    }
}
