//
//  HomeCellNormal.swift
//  Weibo
//
//  Created by Kevin on 2019/2/8.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class HomeCellNormal: HomeCell {
    
    override var homeModel:HomeLineModel?{
        didSet{
            picsView.snp.updateConstraints { (make) in
                // 图片细节调整
                let topMargin = homeModel?.thumbnailUrls?.count ?? 0 > 0 ? HOME_MARGIN : 0
                make.top.equalTo(contentLabel.snp.bottom).offset(topMargin)
            }
        }
    }
    
    override func init_all() {
        super.init_all()
        
        init_set()
    }
    
    private func init_set(){
        /// 图片视图
        picsView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(HOME_MARGIN)
            make.left.equalTo(contentLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(90)
        }
    }
}
