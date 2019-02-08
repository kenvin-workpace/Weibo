//
//  TableViewCellHome.swift
//  Weibo
//
//  Created by Kevin on 2019/2/7.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

let HOME_MARGIN : CGFloat = 10
let HOME_PIC_SIZE : CGFloat = 44

class HomeCell: UITableViewCell {
    
    /// 顶部视图
    private lazy var topView = HomeCellTopView()
    /// 内容视图
    lazy var contentLabel = UILabel(title: "微博正文",screenInset:CGFloat(HOME_MARGIN))
    /// 图片视图
    lazy var picsView = HomeCellPicsView()
    /// 底部视图
    lazy var bottomView = HomeCellBottomView()
    
    var homeModel:HomeLineModel?{
        didSet{
            // 顶部视图
            topView.homeModel = homeModel
            // 内容视图
            contentLabel.text = homeModel?.homeline.text
            // 图片视图
            picsView.homeModel = homeModel
            picsView.snp.updateConstraints { (make) in
                make.width.equalTo(picsView.bounds.width)
                make.height.equalTo(picsView.bounds.height)
            }
        }
    }
    
    /// 根据指定视图计算行高
    func rowHeigth(model:HomeLineModel) -> CGFloat {
        // 记录视图模型 -> 会调用上面的didSet 设置内容以及更新约束
        homeModel = model
        // 强制更新约束
        contentView.layoutIfNeeded()
        // 返回底部视图的最大高度
        return bottomView.frame.maxY
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        init_all()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCell{
    
    @objc func init_all(){
        init_set()
        init_view()
        init_view_layout()
    }
    
    private func init_set(){
        selectionStyle = .none
    }
    
    /// 添加控件
    private func init_view() {
        // 顶部视图
        contentView.addSubview(topView)
        // 内容视图
        contentView.addSubview(contentLabel)
        /// 图片视图
        contentView.addSubview(picsView)
        // 底部视图
        contentView.addSubview(bottomView)
    }
    
    /// 为view设置自动布局
    private func init_view_layout(){
        // 顶部视图
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(2*HOME_MARGIN+HOME_PIC_SIZE)
        }
        // 内容视图
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(2*HOME_MARGIN)
            make.left.equalTo(topView.snp.left).offset(HOME_MARGIN)
            make.right.equalTo(contentView.snp.right).offset(-HOME_MARGIN)
        }
        // 底部视图
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(picsView.snp.bottom).offset(HOME_MARGIN)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.height.equalTo(44)
        }
    }
}
