//
//  HomeLineViewModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

class HomeLineViewModel {
    
   lazy var homeLineModel = [HomeLineModel]()
    
}

extension HomeLineViewModel{
    
    /// 加载数据
    func load_home_data(callback:@escaping (_ isSuccess:Bool)->()){
        WeiboNet.shareInstance.homeTimeLine { (result) in
            let resultDict = result as AnyObject
            guard let dicts = resultDict["statuses"] as? [[String:Any]] else{
                print("TableViewControllerHome,method:init_load_home_data,error = guard let dict = resultDict..)")
                callback(false)
                return
            }
            //可变数组
            var dictArr = [HomeLineModel]()
            //遍历
            for dict in dicts{
                dictArr.append(HomeLineModel(homeline: HomeLine(dict: dict)))
                //print(HomeLine(dict: dict))
            }
            //print(dictArr)
            self.homeLineModel = dictArr+self.homeLineModel
            callback(true)
        }
    }
}
