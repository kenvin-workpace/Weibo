//
//  CollectionViewControllerFeature.swift
//  Weibo
//
//  Created by Kevin on 2019/2/5.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionViewControllerFeature_Cell"
private let CollectionViewImgCount = 4

class CollectionViewControllerFeature: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = WeiboUtil.shareInstance.getScreenBounds().size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        super.init(collectionViewLayout: layout)
        
        init_collection_setting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func init_collection_setting(){
        //去除弹簧
        self.collectionView.bounces = false
        //分页效果
        self.collectionView.isPagingEnabled = true
        //背景为白色
        self.collectionView.backgroundColor = UIColor.white
        //去除水平滚动条
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(CollectionViewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionViewImgCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewFeatureCell
        cell.imgViewIndex = indexPath.item
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //最后一页
        let count = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        if count !=  CollectionViewImgCount - 1{
            return
        }
        //显示按钮，并执行动画
        let cell = collectionView.cellForItem(at: NSIndexPath(item: count, section: 0) as IndexPath) as! CollectionViewFeatureCell
        cell.start_animator()
    }
}

private class CollectionViewFeatureCell : UICollectionViewCell{
    
    //图片
    lazy var imgView = UIImageView()
    //按钮
    lazy var btnView = UIButton(title: "开始体验", color: UIColor.white, fontSize: 14, backgroundImg: "new_feature_finish_button")
    
    @objc func startUse(){
        print("start use")
        NotificationCenter.default.post(name: CUSTOM_SWITCH_NOTIFICATIONCENTER, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        init_view()
        init_autolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imgViewIndex:Int = 0{
        didSet{
            btnView.isHidden = true
            imgView.image = UIImage(named: "new_feature_\(imgViewIndex+1)")
        }
    }
    
    private func init_view(){
        //添加控件
        addSubview(imgView)
        addSubview(btnView)
        //指定属性
        imgView.frame = bounds
        imgView.backgroundColor = UIColor.orange
        //添加事件
        btnView.addTarget(self, action: #selector(startUse), for: .touchUpInside)
    }
    
    private func init_autolayout(){
        btnView.snp.makeConstraints { (view) in
            view.centerX.equalTo(snp.centerX)
            view.bottom.equalTo(snp.bottom).multipliedBy(0.7)
        }
    }
    
    func start_animator(){
        btnView.isHidden = false
        //隐藏
        btnView.transform = CGAffineTransform(scaleX: 0,y: 0)
        //动画
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
             self.btnView.transform = CGAffineTransform.identity
        }) { (isSuccess) in
            
        }
    }
}
