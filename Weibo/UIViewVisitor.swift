//
//  UIViewVisitor.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import SnapKit

protocol UIViewVisitorDelegate : NSObjectProtocol {
    func clickRegBtn()
    func clickLoginBtn()
}

class UIViewVisitor: UIView {
    
    //圆图片
    lazy var iconImg:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //遮罩
    lazy var darkImg:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //小房子
    lazy var houseImg:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //文本
    lazy var textLabel:UILabel = UILabel(title: "关注一些人，回来这里看看有什么惊喜关注一些人，回来这里看看有什么惊喜")
    //注册按钮
    lazy var registerBtn:UIButton = UIButton(title: "注册", color: UIColor.orange)
    //登录按钮
    lazy var loginBtn:UIButton =  UIButton(title: "登录")
    
    //注册、登录按钮 代理
    weak var delegate:UIViewVisitorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        init_visitor_setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_visitor_setting()
    }
}

// MARK:设置显示的title和icon
extension UIViewVisitor{
    /// 设置显示的title和icon
    func setVisitorView(title:String,iconName:String?) -> Void {
            textLabel.text = title
        guard let icon = iconName else {
            //圆图片自动旋转
            autoIconRotation()
            return
        }
        //要显示的图片
        houseImg.image = UIImage(named: icon)
        //隐藏圆图片
        iconImg.isHidden = true
    }
}

// MARK:自动化布局
extension UIViewVisitor{
    
    @objc private func init_visitor_setting(){
        init_visitor_view()
        init_visitor_delegate()
        init_visitor_view_autolayout()
    }
    
    @objc private func init_visitor_delegate(){
        loginBtn.addTarget(self, action: #selector(loginBtnFunc), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(regBtnFunc), for: .touchUpInside)
    }
    
    @objc private func regBtnFunc(){
        delegate?.clickRegBtn()
    }
    
    @objc private func loginBtnFunc(){
        delegate?.clickLoginBtn()
    }
    
    @objc private func init_visitor_view(){
        //圆图片
        addSubview(iconImg)
        //遮罩
        addSubview(darkImg)
        //小房子
        addSubview(houseImg)
        //文本
        addSubview(textLabel)
        //注册按钮
        addSubview(registerBtn)
        //登录按钮
        addSubview(loginBtn)
        
        //设置背景颜色
        backgroundColor = UIColor.init(white: 237/255.0, alpha: 1)
    }
    
    @objc private func init_visitor_view_autolayout(){
        //允许使用自动布局
        for item in subviews {
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //圆图片
        addConstraint(NSLayoutConstraint(item: iconImg, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImg, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -65))
        //小房子
        addConstraint(NSLayoutConstraint(item: houseImg, attribute: .centerX, relatedBy: .equal, toItem: iconImg, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseImg, attribute: .centerY, relatedBy: .equal, toItem: iconImg, attribute: .centerY, multiplier: 1.0, constant: 0))
        //文本
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: iconImg, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: iconImg, attribute: .bottom, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: getScreenWidth()-64))
        addConstraint(NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20))
        //注册按钮
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .left, relatedBy: .equal, toItem: textLabel, attribute: .left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 30))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        //登录按钮
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .right, relatedBy: .equal, toItem: textLabel, attribute: .right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .bottom, multiplier: 1.0, constant: 25))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100))
        //遮罩
        //VFL：可视格式化语言 H：水平方向 V：垂直方向 |：边界 []：包装控件
        //views：是一个字典[名字：控件名]
        //metrics：是一个字典[名字：NSNumber]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mask]-0-|", options: [], metrics: nil, views: ["mask":darkImg]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[mask]-(btnHeight)-[regBtn]", options: [], metrics: ["btnHeight":-40], views: ["mask":darkImg,"regBtn":registerBtn]))
    }
    
    /// 自动旋转
    @objc private func autoIconRotation(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.byValue = Double.pi
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.duration = 10
        iconImg.layer.add(animation, forKey: nil)
    }
    
    /// 屏幕宽度
    @objc private func getScreenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
}
