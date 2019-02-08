//
//  HomeCellPicsView.swift
//  Weibo
//
//  Created by Kevin on 2019/2/8.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import SDWebImage

let HomeCellPicsView_Cell_ID = "HomeCellPicsView_Cell_ID"

class HomeCellPicsView: UICollectionView {
    
    var homeModel:HomeLineModel?{
        didSet{
            sizeToFit()
            reloadData()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return calc_size()
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = HOME_MARGIN
        layout.minimumInteritemSpacing = HOME_MARGIN
        
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        init_setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeCellPicsView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeModel?.thumbnailUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellPicsView_Cell_ID, for: indexPath) as! HomeCellPicsViewCell
        cell.imgUrl = homeModel?.thumbnailUrls?[indexPath.item]
        return cell
    }
}

private class HomeCellPicsViewCell : UICollectionViewCell{
    
    var imgUrl:URL?{
        didSet{
            iconView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "avatar_default_big"), options: [SDWebImageOptions.retryFailed,SDWebImageOptions.refreshCached], completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        init_view_layout()
    }
    
    private func init_view_layout(){
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView.snp.edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconView : UIImageView = {
        let img = UIImageView()
        img.contentMode = UIView.ContentMode.scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
}

extension HomeCellPicsView{
    
    private func init_setting(){
        // 背景颜色
        backgroundColor = UIColor.clear
        // 设置数据源
        dataSource = self
        // 注册可重用cell
        register(HomeCellPicsViewCell.self, forCellWithReuseIdentifier: HomeCellPicsView_Cell_ID)
    }
    
    private func calc_size()->CGSize{
        // 每行的照片数量
        let rowCount: CGFloat = 3
        // 最大宽度
        let maxWidth = UIScreen.main.bounds.width - 2 * HOME_MARGIN
        let itemWidth = (maxWidth - 2 * HOME_MARGIN) / rowCount
        // 设置 layout 的 itemSize
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        // 获取图片数量
        let count = homeModel?.thumbnailUrls?.count ?? 0
        // 没有图片
        if count == 0 {
            return CGSize.zero
        }
        // 一张图片
        if count == 1 {
            let size = CGSize(width: 150, height: 120)
            // 内部图片的大小
            layout.itemSize = size
            // 配图视图的大小
            return size
        }
        
        // 四张图片 2 * 2 的大小
        if count == 4 {
            let w = 2 * itemWidth + HOME_MARGIN
            return CGSize(width: w, height: w)
        }
        // 其他图片 按照九宫格来显示
        let row = CGFloat((count - 1) / Int(rowCount) + 1)
        let h = row * itemWidth + (row - 1) * HOME_MARGIN + 1
        let w = rowCount * itemWidth + (rowCount - 1) * HOME_MARGIN + 1
        return CGSize(width: w, height: h)
    }
}
