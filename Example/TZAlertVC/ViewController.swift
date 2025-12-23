//
//  ViewController.swift
//  TZAlertVC
//
//  Created by Leery TT on 12/22/2025.
//  Copyright (c) 2025 Leery TT. All rights reserved.
//

import UIKit
import TZAlertVC
import TZButton

class ViewController: UIViewController {
    
    lazy var button:UIButton = {
        let btn = UIButton(frame: CGRect(x: 50, y: 100, width: 120, height: 80))
        btn.setTitle("Show Alert", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        return btn
    }()
    
    lazy var button2:UIButton = {
        let btn = UIButton(frame: CGRect(x: 200, y: 100, width: 120, height: 80))
        btn.setTitle("Show Sheet", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(showSheet), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(self.button)
        view.addSubview(self.button2)
    }
    
    @objc func showAlert(){
        let vw = TestAlertView()
        let alert = TZAlertVC.showAlert(with: vw, position: .center,maxWidth: UIScreen.main.bounds.width)
        vw.block = {[weak alert] in
            guard let alert = alert else { return }
            alert.dismiss()
        }
        
    }
    
    @objc func showSheet(){
        let vw = TestAlertView()
        let alert = TZAlertVC.showAlert(with: vw, position: .bottom,maxWidth: UIScreen.main.bounds.width)
        vw.block = {[weak alert] in
            guard let alert = alert else { return }
            alert.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class TestAlertView:UIView{
    lazy var titleLab:TZButton = {
        let lab = TZButton(imagePosition: .onlyText)
        lab.translatesAutoresizingMaskIntoConstraints = false
//        lab.text = "标题"
        lab.setTitle("标题", for: .normal)
        lab.setTitleColor(UIColor.black, for: .normal)
        lab.setFont(UIFont.systemFont(ofSize: 16, weight: .bold))
        lab.setInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        return lab
    }()
    
    lazy var content:UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容测试内容"
        lab.numberOfLines = 0
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.textAlignment = .center
        return lab
    }()
    lazy var cancel:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.addTarget(self, action: #selector(cancelHandler), for: .touchUpInside)
        return btn
    }()
    
//    lazy var confirm:UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("确定", for: .normal)
//        btn.setTitleColor(.blue, for: .normal)
//        btn.addTarget(self, action: #selector(confirmHandler), for: .touchUpInside)
//        return btn
//    }()
    var block:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        layer.cornerRadius = 12.0
        backgroundColor = .white
        addSubview(self.titleLab)
        addSubview(self.content)
        addSubview(self.cancel)
        NSLayoutConstraint.activate([
            titleLab.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLab.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLab.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            content.topAnchor.constraint(equalTo: titleLab.bottomAnchor, constant: 8),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            content.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-64),
            content.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            content.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -80),

            cancel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancel.heightAnchor.constraint(equalToConstant: 44),
            cancel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
//            cancel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-32),
            
        ])
    }
    
    @objc func cancelHandler(){
        self.block?()
    }
    
    @objc func confirmHandler(){
        
    }
}
