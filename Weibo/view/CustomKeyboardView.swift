//
//  CustomKeyboardView.swift
//  KeyBoardView
//
//  Created by Kevin on 2019/2/11.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import SnapKit

private let CustomKeyboardView_CELL_ID = "CustomKeyboardView_CELL_ID"

class CustomKeyboardView: UIView {
    
    init(callback:@escaping (_ emoticon:Emoticon)->()) {
        emojiCallback = callback
        // 设置collection height
        var rect = UIScreen.main.bounds
        rect.size.height = 226
        super.init(frame: rect)
        init_view()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mToolbar = UIToolbar()
    private var emojiCallback:(_ emoticon:Emoticon)->()
    private lazy var packages = EmoticonManger.shareManger.packages
    private lazy var mCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CustomKeyboardFlowLayout())
}

// MARK: toolbar item click event
extension CustomKeyboardView{
    
    @objc func clickItem(item:UIBarButtonItem){
        let indexpath = IndexPath(item: 0, section: item.tag)
        mCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .left)
    }
}

// MARK: collection datasource、delegate
extension CustomKeyboardView : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomKeyboardView_CELL_ID, for: indexPath) as! CustomKeyboardViewCell
        cell.emotion = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = packages[indexPath.section].emoticons[indexPath.item]
        emojiCallback(item)
    }
}

// MARK: collection view cell
private class CustomKeyboardViewCell : UICollectionViewCell{
    
    var emotion : Emoticon?{
        didSet{
            // emoji表情
            btnView.setTitle(emotion?.code?.emoji, for: .normal)
            // 设置表情
            btnView.setImage(UIImage(contentsOfFile: emotion?.imgPath ?? ""), for: .normal)
            // 是否添加删除按钮
            if emotion!.isRemove {
                btnView.setImage(UIImage(named: "compose_emotion_delete"), for: UIControl.State.normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        init_view()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func init_view(){
        // 添加表情按钮
        contentView.addSubview(btnView)
        // 设置按钮属性
        btnView.backgroundColor = UIColor.white
        btnView.isUserInteractionEnabled = false
        btnView.setTitleColor(UIColor.black, for: .normal)
        btnView.frame = bounds.insetBy(dx: 4, dy: 4)
        btnView.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
    
    private lazy var btnView = UIButton()
}

// MARK: add set view
private extension CustomKeyboardView{
    
    func init_view(){
        // 添加子View
        addSubViews()
        // 自动布局
        viewAutoLayout()
        // 准备view数据
        prepareViewData()
    }
    
    /// 准备view数据
    func prepareViewData(){
        // 准备toolbar数据
        prepareToolbarData()
        // 准备collection数据
        prepareCollectionData()
    }
    
    /// 准备collection数据
    func prepareCollectionData(){
        // 背景颜色
        mCollectionView.backgroundColor = UIColor.lightGray
        // 注册cell
        mCollectionView.register(CustomKeyboardViewCell.self, forCellWithReuseIdentifier: CustomKeyboardView_CELL_ID)
        // 代理设置
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
    }
    
    /// 准备toolbar数据
    func prepareToolbarData(){
        var btnItems = [UIBarButtonItem]()
        var index = -1
        for item in packages{
            let btn = UIBarButtonItem(title: item.group_name_cn, style: .plain, target: nil, action: #selector(clickItem(item:)))
            index += 1
            btn.tag = index
            btnItems.append(btn)
            // 可拉伸弹簧
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            btnItems.append(flexible)
        }
        // 移除最后一个可拉伸弹簧
        btnItems.removeLast()
        // 添加到toolbar上
        mToolbar.items = btnItems
        // 设置toolbar颜色为深灰色
        mToolbar.tintColor = UIColor.darkGray
    }
    
    /// 自动布局
    func viewAutoLayout(){
        mCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(mToolbar.snp.top)
        }
        mToolbar.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
            make.height.equalTo(44)
        }
    }
    
    /// 添加子View
    func addSubViews(){
        // 表情区域
        addSubview(mCollectionView)
        // 工具栏区域
        addSubview(mToolbar)
    }
}

// MARK: flow layout
private class CustomKeyboardFlowLayout : UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
        // 行 列
        let col:CGFloat = 7
        let row:CGFloat = 3
        // 宽/高 间距
        let width = UIScreen.main.bounds.width / col
        let margin = (collectionView!.bounds.height - row * width) * 0.449
        // flowlayout item 大小
        itemSize = CGSize(width: width, height: width)
        // flowlayout 属性设置
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        // collectionView 属性设置
        collectionView?.bounces = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
