//
//  TableViewControllerDiscover.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class TableViewControllerDiscover: ViewControllerVisitor {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_view_setting()
    }
}


extension TableViewControllerDiscover{
    
    @objc private func init_view_setting(){
        visitorView?.setVisitorView(title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过", iconName: "visitordiscover_feed_image_house")
    }
}
