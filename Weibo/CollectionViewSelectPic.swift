//
//  CollectionViewSelectPic.swift
//  SelectPicView
//
//  Created by Kevin on 2019/2/18.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionViewSelectPic_Cell"
private let selectPicMaxCount = 9

class CollectionViewSelectPic: UICollectionViewController {
    // 图片数组
    lazy var pictures = [UIImage]()
    // 选择照片的索引
    private var indexPic = 0
    
    init() {
        super.init(collectionViewLayout: PicSelectFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_set()
    }
    
    func init_set(){
        // 背景颜色
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 0.6)
        // 注册可重用Cell
        self.collectionView!.register(PicSelectCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK:  UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension CollectionViewSelectPic : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 添加图片
        var img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if picker.allowsEditing {
            img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        }
        let scaleImg = img.scaleToWidth(width: 600)
        // 是否达到最高照片数量
        if indexPic >= pictures.count {
            pictures.append(scaleImg)
        }else{
            pictures[indexPic] = scaleImg
        }
        
        // 取消控制器
        dismiss(animated: true) {
            // 刷新CollectionView
            self.collectionView.reloadData()
        }
    }
}

// MARK: PicSelectDelegate method
extension CollectionViewSelectPic : PicSelectDelegate {
    
    func clickSelectPic(cell: PicSelectCell) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("没有权限访问相册")
            return
        }
        // 记录当前照片索引
        indexPic = collectionView?.indexPath(for: cell)?.item ?? 0
        
        // 显示照片访问控制器
        let vc = UIImagePickerController()
        
        //是否允许编辑照片
        //vc.allowsEditing = true
        
        // 设置代理
        vc.delegate = self;
        present(vc, animated: true, completion: nil)
    }
    
    func clickDeletePic(cell: PicSelectCell) {
        let indexPath = collectionView.indexPath(for: cell)!
        if indexPath.item >= pictures.count {
            return
        }
        pictures.remove(at: indexPath.item)
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewSelectPic{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count + (pictures.count==selectPicMaxCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PicSelectCell
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        // 设置代理
        cell.delegatePic = self;
        return cell
    }
}

// MARK: PicSelectFlowLayout
class PicSelectFlowLayout : UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        
        let count:CGFloat = 4
        let margin = UIScreen.main.scale * count
        let width = (collectionView!.bounds.width - (count + 1)*margin)/count
        
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
    }
}

// MARK: picSelect delegate
@objc
protocol PicSelectDelegate : NSObjectProtocol {
    @objc optional func clickSelectPic(cell:PicSelectCell)
    @objc optional func clickDeletePic(cell:PicSelectCell)
}

// MARK: view event
extension PicSelectCell{
    
    @objc func slectPic(){
        print("添加照片")
        delegatePic?.clickSelectPic?(cell: self)
    }
    
    @objc func deletePic(){
        print("删除照片")
        delegatePic?.clickDeletePic?(cell: self)
    }
}

class PicSelectCell : UICollectionViewCell{
    
    weak var delegatePic:PicSelectDelegate?
    
    var image:UIImage?{
        didSet{
            btnSelectView.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            deleteIconView.isHidden = (image == nil)
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
        // 添加控件
        addSubview(btnSelectView)
        // 照片显示大小
        btnSelectView.frame = bounds
        // 照片显示模式
        btnSelectView.imageView?.contentMode = .scaleAspectFill
        btnSelectView.addSubview(deleteIconView)
        // 自动布局
        deleteIconView.snp.makeConstraints { (make) in
            make.right.equalTo(btnSelectView.snp.right)
            make.top.equalTo(btnSelectView.snp.top)
        }
        // 添加点击事件
        btnSelectView.addTarget(self, action: #selector(slectPic), for: .touchUpInside)
        deleteIconView.addTarget(self, action: #selector(deletePic), for: .touchUpInside)
    }
    
    // 点击按钮图片
    private lazy var btnSelectView : UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
        return btn
    }()
    // 点击删除图片
    private lazy var deleteIconView : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_photo_close"), for: .normal)
        btn.sizeToFit()
        return btn
    }()
}
