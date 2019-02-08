//
//  HomeLineModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeLineModel : CustomStringConvertible{
    
    var homeline:HomeLine
    
    /// 缩略图URL
    var thumbnailUrls:[URL]?
    
    /// 缓存行高
    lazy var rowHeight : CGFloat = {
        var cell : HomeCell
        if homeline.retweeted_status == nil{
            cell = HomeCellNormal(style: .default, reuseIdentifier: Home_Cell_Normal_ID)
        }else{
            cell = HomeCellRetweet(style: .default, reuseIdentifier: Home_Cell_Retweet_ID)
        }
        return cell.rowHeigth(model: self)
    }()
    
    // 转发文本
    var retweetText : String?{
        guard let text = homeline.retweeted_status else{
            return nil
        }
        return String(describing: "@"+(text.user?.screen_name ?? "") + ":" + (text.text ?? ""))
    }
    
    // 选择cell id
    var selectCellID : String{
        return homeline.retweeted_status != nil ? Home_Cell_Retweet_ID : Home_Cell_Normal_ID
    }
    
    init(homeline:HomeLine) {
        self.homeline = homeline
        
        if let urls = homeline.retweeted_status?.pic_urls ?? homeline.pic_urls {
            thumbnailUrls = [URL]()
            for dict in urls{
                let url = NSURL(string: dict["thumbnail_pic"]!)! as URL
                thumbnailUrls?.append(url)
            }
        }
    }
    
    var description: String{
        return homeline.description + String(describing: thumbnailUrls)
    }
}

extension HomeLineModel{
    
    /// 获取用户头像
    var headerPic:URL{
        return NSURL(string: homeline.user?.profile_image_url ?? "")! as URL
    }
    
    /// 徽章
    var memberPic:UIImage?{
        if homeline.user?.mbrank ?? -1 > 0 && homeline.user?.mbrank ?? 8 < 7{
            return UIImage(named: "common_icon_membership_level\(homeline.user!.mbrank)")
        }
        return nil
    }
    
    /// vip标示，-1:没有认证，0：认证用户，2，3，5:企业认证，220:达人
    var vipPic:UIImage?{
        switch homeline.user?.verified_type {
        case 0:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
}
