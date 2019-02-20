//
//  ViewControllerBrowsePic.swift
//  Weibo
//
//  Created by Kevin on 2019/2/19.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewControllerBrowsePic: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_all()
    }
    
    private lazy var btnClose : UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControl.State.normal)
        return btn
    }()
}


// MARK: init all
extension ViewControllerBrowsePic{
    
    func init_all(){
        // 添加子控件
        view.addSubview(btnClose)
        // 自动布局
        btnClose.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(HOME_MARGIN)
            make.bottom.equalTo(view.snp.bottom).offset(HOME_MARGIN)
        }
        // 点击事件
    }
}
