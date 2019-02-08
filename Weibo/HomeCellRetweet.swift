//
//  HomeCellRetweet.swift
//  Weibo
//
//  Created by Kevin on 2019/2/8.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeCellRetweet: HomeCell {
    
    override var homeModel:HomeLineModel?{
        didSet{
            // 设置转发文本
            retweetTextView.text = homeModel?.retweetText
            picsView.snp.updateConstraints { (make) in
                // 图片细节调整
                let topMargin = homeModel?.thumbnailUrls?.count ?? 0 > 0 ? HOME_MARGIN : 0
                make.top.equalTo(retweetTextView.snp.bottom).offset(topMargin)
            }
        }
    }
    
    override func init_all() {
        super.init_all()
        init_set()
    }
    
    private func init_set(){
        // 转发背景
        contentView.insertSubview(retweetBgView, belowSubview: picsView)
        retweetBgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(HOME_MARGIN)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(bottomView.snp.top)
        }
        /// 转发文本
        contentView.insertSubview(retweetTextView, aboveSubview: retweetBgView)
        retweetTextView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetBgView.snp.top).offset(HOME_MARGIN)
            make.left.equalTo(contentLabel.snp.left)
            make.right.equalTo(retweetBgView.snp.right)
        }
        
        /// 图片视图
        picsView.snp.makeConstraints { (make) in
            make.top.equalTo(retweetTextView.snp.bottom).offset(HOME_MARGIN)
            make.left.equalTo(contentLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
    
    /// 转发背景
    private lazy var retweetBgView : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        return btn
    }()
    
    /// 转发文本
    private lazy var retweetTextView : UILabel = {
        let text = UILabel(title: "转发文本", fontSize: 13, screenInset: HOME_MARGIN)
        return text
    }()
}
