//
//  HomeCellTopView.swift
//  Weibo
//
//  Created by Kevin on 2019/2/7.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeCellTopView: UIView {
    
    // 头像
    private lazy var headerPic: UIImageView = {
        let img = UIImageView(image: UIImage(named: "avatar_default_big"))
        img.layer.cornerRadius = 5
        img.layer.masksToBounds = true
        return img
    }()
    // 昵称
    private lazy var nameLabel = UILabel(title: "王洪振")
    // 徽章
    private lazy var memberPic = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    // vip标示
    private lazy var vipPic = UIImageView(image: UIImage(named: "avatar_vip"))
    // 发送时间
    private lazy var timeLabel = UILabel(title: "2017/12/12")
    // 来源提示
    private lazy var sourceLabel = UILabel(title: "来自微信")
    
    var homeModel:HomeLineModel?{
        didSet{
            // 头像
            headerPic.sd_setImage(with: homeModel?.headerPic, placeholderImage: UIImage(named: "avatar_default_big"), options: [], completed: nil)
            // 昵称
            nameLabel.text = homeModel?.homeline.user?.screen_name
            // 徽章
            memberPic.image = homeModel?.memberPic
            // vip标示
            vipPic.image = homeModel?.vipPic
            // 发送时间
            // TODO: timeLabel.text = homeModel?.homeline.created_at
            // 来源提示
            // TODO: sourceLabel.text = homeModel?.homeline.source
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        init_view()
        init_view_autolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCellTopView{
    
    func init_view() -> Void {
        // 头像
        addSubview(headerPic)
        // 昵称
        addSubview(nameLabel)
        // 徽章
        addSubview(memberPic)
        // vip标示
        addSubview(vipPic)
        // 发送时间
        addSubview(timeLabel)
        // 来源提示
        addSubview(sourceLabel)
    }
    
    func init_view_autolayout() -> Void {
        // 水平间距
        let space = create_view()
        addSubview(space)
        space.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(HOME_MARGIN)
        }
        // 头像
        headerPic.snp.makeConstraints { (make) in
            make.top.equalTo(space.snp.top).offset(2*HOME_MARGIN)
            make.left.equalTo(snp.left).offset(HOME_MARGIN)
            make.width.equalTo(HOME_PIC_SIZE)
            make.height.equalTo(HOME_PIC_SIZE)
        }
        // 昵称
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerPic.snp.top)
            make.left.equalTo(headerPic.snp.right).offset(HOME_MARGIN)
        }
        // 徽章
        memberPic.snp.makeConstraints { (make) in
            make.top.equalTo(headerPic.snp.top)
            make.left.equalTo(nameLabel.snp.right).offset(HOME_MARGIN)
        }
        // vip标示
        vipPic.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerPic.snp.right)
            make.centerY.equalTo(headerPic.snp.bottom)
        }
        // 发送时间
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerPic.snp.right).offset(HOME_MARGIN)
            make.bottom.equalTo(headerPic.snp.bottom)
        }
        // 来源提示
        sourceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(HOME_MARGIN)
            make.bottom.equalTo(headerPic.snp.bottom)
        }
    }
}

extension HomeCellTopView{
    
    private func create_view()->UIView{
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.7)
        return view
    }
}
