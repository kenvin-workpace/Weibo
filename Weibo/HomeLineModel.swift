//
//  HomeLineModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeLineModel{
    
    var homeline:HomeLine
    
    /// 缩略图URL
    
    
    init(homeline:HomeLine) {
        self.homeline = homeline
        
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