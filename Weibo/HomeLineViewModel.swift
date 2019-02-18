//
//  HomeLineViewModel.swift
//  Weibo
//
//  Created by Kevin on 2019/2/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation
import SDWebImage

class HomeLineViewModel {
    
    lazy var homeLineModel = [HomeLineModel]()
    
}

extension HomeLineViewModel{
    
    /// 加载数据
    func load_home_data(isPullUp:Bool,callback:@escaping (_ isSuccess:Bool)->()){
        // 下拉数据，数据内的第一条数据
        let sinceid = isPullUp ? 0 : (homeLineModel.first?.homeline.id ?? 0)
        // 上拉数据，数据内的最后一条数据
        let maxid = isPullUp ? (homeLineModel.last?.homeline.id ?? 0) : 0
        
        WeiboNet.shareInstance.homeTimeLine(since_id: sinceid, max_id: maxid) { (result) in
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
            if maxid > 0{
                self.homeLineModel += dictArr
            }else {
                self.homeLineModel = dictArr + self.homeLineModel
            }
            //缓存单张图片
            self.cacheSingleImg(modelArr: dictArr,finished: callback)
        }
    }
    
    func cacheSingleImg(modelArr:[HomeLineModel],finished:@escaping (_ isSuccess:Bool)->()) -> Void {
        let group = DispatchGroup()
        
        //判断图片是否是单张
        for model in modelArr{
            if model.thumbnailUrls?.count != 1{
                continue
            }
            // 获取URL
            let url =  model.thumbnailUrls![0]
            // 入组
            group.enter()
            
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.useNSURLCache, progress: nil, completed: { (img, data, error, isSuccess) in
                // 出组
                group.leave()
            })
        }
        //调度组完成
        group.notify(queue: DispatchQueue.main) {
            finished(true)
        }
    }
}
