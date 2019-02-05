//
//  TableViewControllerHome.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class TableViewControllerHome: ViewControllerVisitor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_view_setting()
    }
}

extension TableViewControllerHome{
    
    @objc private func init_view_setting(){
        visitorView?.setVisitorView(title: "关注一些人，回来这里看看有什么惊喜", iconName: nil)
    }
}
