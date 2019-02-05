//
//  UIButton+Extendsion.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(iconName:String,backgroundIconName:String) {
        self.init()
        //设置图片
        setImage(UIImage(named: iconName), for: UIControl.State.normal)
        setImage(UIImage(named: iconName+"_highlighted"), for: UIControl.State.highlighted)
        //设置背景图片
        setBackgroundImage(UIImage(named: backgroundIconName), for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: backgroundIconName+"_highlighted"), for: UIControl.State.normal)
        //根据背景图片自适应大小
        sizeToFit()
    }
    
    convenience init(title:String,color:UIColor = UIColor.darkGray,fontSize:CGFloat = 14,backgroundImg:String = "common_button_white_disable"){
        self.init()
        //显示文字
        setTitle(title, for: UIControl.State.normal)
        //字体大小
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        //字体颜色
        setTitleColor(color, for: UIControl.State.normal)
        //按钮背景图片
        setBackgroundImage(UIImage(named: backgroundImg), for: UIControl.State.normal)
    }
}
