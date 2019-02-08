//
//  HomeCellBottomView.swift
//  Weibo
//
//  Created by Kevin on 2019/2/7.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

let LINE_WIDTH = 0.5
let LINE_SCALE = 0.4

class HomeCellBottomView: UIView {
    
    /// 转发
    private lazy var retweetBtn = UIButton(title: " 转发", img: "timeline_icon_retweet")
    /// 评论
    private lazy var comentBtn = UIButton(title: " 评论", img: "timeline_icon_comment")
    /// 点赞
    private lazy var likeBtn = UIButton(title: " 点赞", img: "timeline_icon_unlike")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        init_set()
        init_view()
        init_view_layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeCellBottomView{
    
    private func init_view(){
        /// 转发
        addSubview(retweetBtn)
        /// 评论
        addSubview(comentBtn)
        /// 点赞
        addSubview(likeBtn)
    }
    
    private func init_view_layout(){
        /// 转发
        retweetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.bottom.equalTo(snp.bottom)
        }
        /// 评论
        comentBtn.snp.makeConstraints { (make) in
            make.top.equalTo(retweetBtn.snp.top)
            make.left.equalTo(retweetBtn.snp.right)
            make.width.equalTo(retweetBtn.snp.width)
            make.height.equalTo(retweetBtn.snp.height)
        }
        /// 点赞
        likeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(retweetBtn.snp.top)
            make.left.equalTo(comentBtn.snp.right)
            make.width.equalTo(retweetBtn.snp.width)
            make.height.equalTo(retweetBtn.snp.height)
            make.right.equalTo(snp.right)
        }
        /// 分割线1
        let view1 = create_view()
        addSubview(view1)
        view1.snp.makeConstraints { (make) in
            make.right.equalTo(retweetBtn.snp.right)
            make.centerY.equalTo(retweetBtn.snp.centerY)
            make.width.equalTo(LINE_WIDTH)
            make.height.equalTo(retweetBtn.snp.height).multipliedBy(LINE_SCALE)
        }
        /// 分割线2
        let view2 = create_view()
        addSubview(view2)
        view2.snp.makeConstraints { (make) in
            make.right.equalTo(comentBtn.snp.right)
            make.centerY.equalTo(comentBtn.snp.centerY)
            make.width.equalTo(LINE_WIDTH)
            make.height.equalTo(retweetBtn.snp.height).multipliedBy(LINE_SCALE)
        }
    }
}

extension HomeCellBottomView{
    
    private func init_set(){
        backgroundColor = UIColor(white: 0.9, alpha: 0.3)
    }
    
    private func create_view()->UIView{
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }
}
