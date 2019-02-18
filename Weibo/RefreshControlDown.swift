//
//  RefreshControlPullDown.swift
//  Weibo
//
//  Created by Kevin on 2019/2/9.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

private let PullDownView_offset:CGFloat = -60

class RefreshControlDown: UIRefreshControl {
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopAnimation()
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.startAnimation()
    }
    
    override init() {
        super.init()
        init_view()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        init_view()
    }
    
    // MARK: - 懒加载控件
    private lazy var refreshView = RefreshDownView.refreshView()
    
    private func init_view(){
        //隐藏菊花
        tintColor = UIColor.clear
        //添加控件
        addSubview(refreshView)
        // 自动布局 - 从 `XIB 加载的控件`需要指定大小约束
        refreshView.snp.makeConstraints({ (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        })
        //使用kVO监听位置变化
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if frame.origin.y > 0{
            return
        }
        refreshView.startAnimation()
    }
    
    deinit {
        //删除KVO监听
        self.removeObserver(self, forKeyPath: "frame")
    }
    
}

class RefreshDownView : UIView{
    
    @IBOutlet weak var loadingIconView: UIImageView!
    
    /// 播放动画
    func startAnimation(){
        let key = "transform.rotation"
        // 判断是否已添加动画
        if loadingIconView.layer.animation(forKey: key) != nil {
            return
        }
        
        let animation = CABasicAnimation()
        animation.keyPath = key
        animation.byValue = 2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        loadingIconView.layer.add(animation, forKey: key)
    }
    
    /// 停止动画
    func stopAnimation(){
        loadingIconView.layer.removeAllAnimations()
    }
    
    /// 使用nib方式加载xib
    class func refreshView()->RefreshDownView{
        return Bundle.main.loadNibNamed("RefreshDownView", owner: nil, options: nil)?.last as! RefreshDownView
    }
}
