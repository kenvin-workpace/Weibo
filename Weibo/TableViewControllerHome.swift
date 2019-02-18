//
//  TableViewControllerHome.swift
//  Weibo
//
//  Created by Kevin on 2019/2/2.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

let Home_Cell_Normal_ID = "Home_Cell_Normal_ID"
let Home_Cell_Retweet_ID = "Home_Cell_Retweet_ID"

class TableViewControllerHome: ViewControllerVisitor {
    
    lazy var homeLineViewMode = HomeLineViewModel()
    
    private lazy var pullUpView : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        indicator.color = UIColor.lightGray
        
        return indicator
    }()
    
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
        let homeModel = homeLineViewMode.homeLineModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: homeModel.selectCellID, for: indexPath) as! HomeCell
        cell.homeModel = homeModel
        //判断是否是最后一条数据
        if indexPath.row == homeLineViewMode.homeLineModel.count-1 && !pullUpView.isAnimating{
            pullUpView.startAnimating()
            init_load_home_data()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return homeLineViewMode.homeLineModel[indexPath.row].rowHeight
    }
    
}

/// MARK: 加载数据
extension TableViewControllerHome{
    
    @objc private func init_load_home_data(){
        // 下拉刷新
        refreshControl?.beginRefreshing()
        
        homeLineViewMode.load_home_data(isPullUp: pullUpView.isAnimating) { (isSuccess) in
            //下拉刷新关闭
            self.refreshControl?.endRefreshing()
            //上拉刷新关闭
            self.pullUpView.stopAnimating()
            
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
        tableView.register(HomeCellNormal.self, forCellReuseIdentifier: Home_Cell_Normal_ID)
        tableView.register(HomeCellRetweet.self, forCellReuseIdentifier: Home_Cell_Retweet_ID)
        //去除分割线
        tableView.separatorStyle = .none
        //预估行高
        tableView.estimatedRowHeight = 400
        //下拉刷新
        refreshControl = RefreshControlDown()
        //添加下拉刷新监听事件
        refreshControl?.addTarget(self, action: #selector(init_load_home_data), for: .valueChanged)
        
        //上拉刷新
        tableView.tableFooterView = pullUpView
    }
    
    
}
