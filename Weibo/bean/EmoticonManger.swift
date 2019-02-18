//
//  EmoticonManger.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/11.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class EmoticonManger {
    // 单例
    static let shareManger = EmoticonManger()
    
    // 表情包模型
    lazy var packages = [EmoticonPackages]()
    
    private init() {
        // 1.添加最近分组
        packages.append(EmoticonPackages(dict: ["group_name_cn":"最近"]))
        // 2.加载emoticon.plist
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 3.加载字典
        let dict = NSDictionary(contentsOfFile: path) as! [String:Any]
        // 4.转为数组
        let ids = (dict["packages"] as! NSArray).value(forKey: "id")
        // 5.遍历id数组，加载info.plist
        for id in ids as! [String]{
            let path = Bundle.main.path(forResource: "info.plist", ofType: nil, inDirectory: "Emoticons.bundle/\(id)")!
            let dict = NSDictionary(contentsOfFile: path) as! [String:Any]
            packages.append(EmoticonPackages(dict: dict))
        }
    }
}
