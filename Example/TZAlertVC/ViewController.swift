//
//  ViewController.swift
//  TZAlertVC
//
//  Created by Leery TT on 12/22/2025.
//  Copyright (c) 2025 Leery TT. All rights reserved.
//

import UIKit
import TZAlertVC

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
        _ = TZAlertVC.showAlert(with: vw, position: .center)
        
    }
    
    @objc func showSheet(){
        let vw = TestAlertView()
        _ = TZAlertVC.showAlert(with: vw, position: .bottom)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class TestAlertView:UIView{
    lazy var titleLab:UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "标题"
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var content:UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.text = "测试内容测试内容测试内容测试内容测试内容测试内容测试内容"
        lab.numberOfLines = 0
        lab.textColor = .black
        lab.font = UIFont.systemFont(ofSize: 14)
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
    
    lazy var confirm:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(confirmHandler), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init(){
//        self.init(frame: CGRect.zero)
        self.init()
        self.setupUI()
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
        addSubview(self.confirm)
        let line = UIView()
        line.backgroundColor = .gray
        line.alpha = 0.5
        addSubview(line)
        NSLayoutConstraint.activate([
            titleLab.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLab.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLab.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLab.heightAnchor.constraint(equalToConstant: 20),
            
            content.topAnchor.constraint(equalTo: titleLab.bottomAnchor, constant: 8),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            content.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 64),
            
            line.topAnchor.constraint(equalTo: content.bottomAnchor,constant: 8),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            
            cancel.topAnchor.constraint(equalTo: line.bottomAnchor),
            cancel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancel.heightAnchor.constraint(equalToConstant: 44),
            cancel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            confirm.centerYAnchor.constraint(equalTo: cancel.centerYAnchor),
            confirm.leadingAnchor.constraint(equalTo: cancel.trailingAnchor),
            confirm.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirm.heightAnchor.constraint(equalToConstant: 44),
            confirm.widthAnchor.constraint(equalTo: cancel.widthAnchor, multiplier: 1)
        ])
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        content.widthAnchor.constraint(equalToConstant: self.bounds.size.width - 32).isActive = true
    }
    
    @objc func cancelHandler(){
        
    }
    
    @objc func confirmHandler(){
        
    }
}
