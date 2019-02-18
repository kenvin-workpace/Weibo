//
//  EmoticonPackages.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/11.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class EmoticonPackages: NSObject {
    // 分组名称
    @objc var id:String?
    // item名称
    @objc var group_name_cn:String?
    // 每个分组到item，使用懒加载保证使用时，一定有值
    @objc lazy var emoticons = [Emoticon]()
    
    init(dict:[String:Any]) {
        super.init()
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        
        if let dicts = dict["emoticons"] as? [[String:Any]]{
            var index = 0
            // 遍历
            for var item in dicts{
                //判断是否是png图片
                if let png = item["png"],let dir = id{
                    // 拼接图片完整路径
                    item["png"] = "\(dir)/\(png)"
                }
                emoticons.append(Emoticon(dict: item))
                //每隔20个添加一个删除按钮
                index += 1
                if index == 20{
                    emoticons.append(Emoticon(isRemove: true))
                    index = 0
                }
            }
        }
        
        // 添加空白按钮
        appendImpty()
    }
    
    /// 添加空白按钮
    func appendImpty(){
        // 取表情的余数
        let count = emoticons.count % 21
        if emoticons.count > 0 && count == 0{
            return
        }
        print("\(group_name_cn!),剩余:\(count)")
        // 添加空白表情
        for _ in count..<20{
            emoticons.append(Emoticon(isEmpty: true))
        }
        // 空白处添加删除按钮
        emoticons.append(Emoticon(isRemove: true))
    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["id","group_name_cn","emoticons"]).description
    }
}
