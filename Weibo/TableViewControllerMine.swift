//
//  TableViewControllerMine.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class TableViewControllerMine: ViewControllerVisitor {

    override func viewDidLoad() {
        super.viewDidLoad()

        init_view_setting()
    }
}

extension TableViewControllerMine{
    
    @objc private func init_view_setting(){
        visitorView?.setVisitorView(title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人", iconName: "visitordiscover_image_mine")
    }
}
