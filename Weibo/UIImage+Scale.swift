//
//  UIImage+Scale.swift
//  SelectPicView
//
//  Created by Kevin on 2019/2/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

extension UIImage{
    
    func scaleToWidth(width:CGFloat) -> UIImage{
        //判断宽度
        if width > size.width{
            return self
        }
        let height = size.height * width / size.width
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        self.draw(in: rect)
        // 获取图片
        let img = UIGraphicsGetImageFromCurrentImageContext()
        //关闭图形上下文
        UIGraphicsEndImageContext()
        return img!
    }
    
}
