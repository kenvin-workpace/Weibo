//
//  UIViewVisitor.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

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
        iconImg.snp.makeConstraints { (view) in
            view.centerX.equalTo(snp.centerX)
            view.centerY.equalTo(snp.centerY).offset(-65)
        }
        //小房子
        houseImg.snp.makeConstraints { (view) in
            view.center.equalTo(iconImg.snp.center)
        }
        //文本
        textLabel.snp.makeConstraints { (view) in
            view.centerX.equalTo(iconImg.snp.centerX)
            view.top.equalTo(iconImg.snp.bottom).offset(10)
            view.width.equalTo(WeiboUtil.shareInstance.getScreenBounds().width-64)
            view.height.equalTo(40)
        }
        //注册按钮
        registerBtn.snp.makeConstraints { (view) in
            view.left.equalTo(textLabel.snp.left)
            view.top.equalTo(textLabel.snp.bottom).offset(30)
            view.width.equalTo(100)
        }
        //登录按钮
        loginBtn.snp.makeConstraints { (view) in
            view.right.equalTo(textLabel.snp.right)
            view.top.equalTo(registerBtn.snp.top)
            view.width.equalTo(100)
        }
        //遮罩
        darkImg.snp.makeConstraints { (view) in
            view.left.equalTo(snp.left)
            view.right.equalTo(snp.right)
            view.top.equalTo(snp.top)
            view.bottom.equalTo(registerBtn.snp.bottom)
        }
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
}
