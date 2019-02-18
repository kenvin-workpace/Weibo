//
//  ViewControllerAnnounce.swift
//  Weibo
//
//  Created by Kevin on 2019/2/15.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class ViewControllerAnnounce: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        init_all()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        inputTextView.becomeFirstResponder()
    }
    
    /// toolbar view
    private lazy var toolbar = UIToolbar()
    /// input textView
    private lazy var inputTextView : UITextView = {
        let textview = UITextView()
        // 允许始终垂直滚动
        textview.alwaysBounceVertical = true
        // 拖拽关闭键盘
        textview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        // 设置代理
        textview.delegate = self
        return textview
    }()
    /// label view
    private lazy var placeHolderTextLabel : UILabel = {
        let label = UILabel(title: "分享新鲜事")
        return label
    }()
    /// 表情键盘视图
    private lazy var emoticonview = CustomKeyboardView {[weak self] (emoticon) in
        self?.inputTextView.showTextPic(emoticon: emoticon)
    }
}
// MARK: View 点击事件
extension ViewControllerAnnounce{
    
    /// 关闭控制器
    @objc func closeNav(){
        inputTextView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    /// 关闭控制器
    @objc func announceNav(){
        print("\(inputTextView.pushTextPic)")
        
        WeiboNet.shareInstance.sendStatus(status: inputTextView.pushTextPic, img: nil) { (result) in
            print("result=\(String(describing: result))")
        }
    }
    
    /// 表情按钮
    @objc func emoticonItem(){
       // 退出键盘
        inputTextView.resignFirstResponder()
        // 设置键盘
        inputTextView.inputView = inputTextView.inputView == nil ? emoticonview : nil
        // 激活键盘
        inputTextView.becomeFirstResponder()
    }
    
    /// 键盘显示/隐藏
    @objc func showHideKeyboard(n:Notification){
        // 键盘高度
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        toolbar.snp.updateConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-rect.height)
        }
        
        // 键盘动画曲线
        let curve = (n.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        
        // 键盘动画时长
        let duration = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(UIView.AnimationCurve(rawValue:curve)!)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: 系统事件
extension ViewControllerAnnounce : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = inputTextView.hasText
        placeHolderTextLabel.isHidden = inputTextView.hasText
    }
}

// MARK: 初始化设置
extension ViewControllerAnnounce{
    
    func init_all(){
        init_set()
        init_toolbar_view()
        init_input_textview()
        init_placeholderlabel_view()
        init_notification_keyboard()
    }
    
    /// navigationItem view
    func init_set(){
        // 背景颜色
        view.backgroundColor = UIColor.white
        // 导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(closeNav))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: nil, action: #selector(announceNav))
        navigationItem.rightBarButtonItem?.isEnabled = false
        // title view
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 36))
        titleView.backgroundColor = UIColor.red
        // title 1
        let text1 = UILabel(title: "发布微博",color:UIColor.black)
        titleView.addSubview(text1)
        text1.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.top)
            make.centerX.equalTo(titleView.snp.centerX)
        }
        // title 2
        let text2 = UILabel(title: "我叫王洪振",fontSize: 13)
        titleView.addSubview(text2)
        text2.snp.makeConstraints { (make) in
            make.top.equalTo(text1.snp.bottom).offset(3)
            make.centerX.equalTo(titleView.snp.centerX)
        }
        navigationItem.titleView = titleView
    }
    
    /// toolbar view
    func init_toolbar_view(){
        // 添加tollbar，并设置自动布局
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(44)
        }
        // 添加图片按钮
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "selectEmoticon"],
                            ["imageName": "compose_addbutton_background"]]
        var itemArr = [UIBarButtonItem]()
        for item in itemSettings{
            // 每个item按钮
            let btn = UIButton(conName: item["imageName"]!, backgroundIconName: nil)
            itemArr.append(UIBarButtonItem(customView: btn))
            // 添加可变弹簧
            itemArr.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            // 能否添加点击事件
            if item["actionName"] != nil {
                btn.addTarget(self, action: #selector(emoticonItem), for: .touchUpInside)
            }
        }
        itemArr.removeLast()
        toolbar.items = itemArr
    }
    
    /// input textView
    func init_input_textview(){
        view.addSubview(inputTextView)
        inputTextView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(CommonUtil.shareInstance.getStatusNavBarHeight(nav:navigationController))
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(toolbar.snp.top)
        }
    }
    
    /// label view
    func init_placeholderlabel_view(){
        inputTextView.addSubview(placeHolderTextLabel)
        placeHolderTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(inputTextView.snp.top).offset(8)
            make.left.equalTo(inputTextView.snp.left).offset(5)
        }
    }
    
    /// notification keyboard
    func init_notification_keyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(showHideKeyboard(n:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}
