//
//  ViewControllerWelcome.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ViewControllerWelcome: UIViewController {
    
    // 背景图片
    private lazy var backgoundView = UIImageView(image: UIImage(named: "ad_background"))
    
    // 头像
    private lazy var headPic:UIImageView = {
        let img = UIImageView(image: UIImage(named: "avatar_default_big"))
        img.layer.cornerRadius = 45
        img.layer.masksToBounds = true
        return img
    }()
    
    // 头像文本
    private lazy var headText = UILabel(title: "欢迎回来",fontSize:16)
    
    override func loadView() {
        init_view()
        init_view_layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        init_update_view()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_head_pic()
    }
}

// MARK: 更新view
extension ViewControllerWelcome{
    
    /// 加载用户头像
    private func load_head_pic(){
        headPic.sd_setImage(with: AccountInfoModel.shareInstance.headPic, placeholderImage: UIImage(named: "avatar_default_big"), options: []) { (image, error, imageCacheType, url) in
            
        }
    }
    
    private func init_update_view(){
        // 头像文本隐藏
        headText.alpha = 0
        // 重设头像位置
        headPic.snp.remakeConstraints { (pic) in
            pic.width.equalTo(90)
            pic.height.equalTo(90)
            pic.centerX.equalTo(view.snp.centerX)
            pic.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height+200)
        }
        //添加动画
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: {
            // 头像文本显示
            self.headText.alpha = 1
            //view重新刷新
            self.view.layoutIfNeeded()
        }) { (isSuccess) in
            // 使用通知到达主界面
            NotificationCenter.default.post(name: CUSTOM_SWITCH_NOTIFICATIONCENTER, object: nil)
        }
    }
}

// MARK: 初始化view
extension ViewControllerWelcome{
    
    private func init_view(){
        // 根背景
        view = backgoundView
        // 头像
        view.addSubview(headPic)
        // 头像文本
        view.addSubview(headText)
    }
    
    private func init_view_layout(){
        
        // 头像
        headPic.snp.makeConstraints { (pic) in
            pic.centerX.equalTo(view.snp.centerX)
            pic.width.equalTo(90)
            pic.height.equalTo(90)
            pic.bottom.equalTo(view.snp.bottom).offset(-200)
        }
        
        // 头像文本
        headText.snp.makeConstraints { (text) in
            text.centerX.equalTo(headPic.snp.centerX)
            text.top.equalTo(headPic.snp.bottom).offset(16)
        }
    }
}
