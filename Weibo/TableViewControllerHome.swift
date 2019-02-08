//
//  TableViewControllerHome.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

let TableViewControllerHomeCell = "TableViewControllerHome_cell"

class TableViewControllerHome: ViewControllerVisitor {
    
    lazy var homeLineViewMode = HomeLineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_view_setting()
        init_load_home_data()
    }
}

/// MARK: tableview
extension TableViewControllerHome{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeLineViewMode.homeLineModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewControllerHomeCell, for: indexPath) as! HomeCell
        cell.homeModel = homeLineViewMode.homeLineModel[indexPath.row]
        return cell
    }
    
 
}

/// MARK: 加载数据
extension TableViewControllerHome{
    
    private func init_load_home_data(){
        
        homeLineViewMode.load_home_data { (isSuccess) in
            if !isSuccess{
                return
            }
            self.tableView.reloadData()
        }
    }
}

/// MARK: 初始化方法
extension TableViewControllerHome{
    
    private func init_view_setting(){
        if !AccountInfoViewModel.shareInstance.isLoginStatus {
            visitorView?.setVisitorView(title: "关注一些人，回来这里看看有什么惊喜", iconName: nil)
            return
        }
        //注册可重用cell
        tableView.register(HomeCell.self, forCellReuseIdentifier: TableViewControllerHomeCell)
        //去除分割线
        tableView.separatorStyle = .none
        //预估行高
        tableView.estimatedRowHeight = 200
        //自动计算行高
        tableView.rowHeight = UITableView.automaticDimension
    }
}
