//
//  TableViewControllerMessage.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class TableViewControllerMessage: ViewControllerVisitor {

    override func viewDidLoad() {
        super.viewDidLoad()

        init_view_setting()
    }
}

extension TableViewControllerMessage{
    
    @objc private func init_view_setting(){
        visitorView?.setVisitorView(title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知", iconName: "visitordiscover_image_message")
    }
}
