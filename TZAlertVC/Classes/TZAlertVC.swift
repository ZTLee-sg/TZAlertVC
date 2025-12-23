
//
//  TZAlertVC.swift
//  wanbiao
//
//  Created by Leery TT on 2025/12/18.
//

import UIKit

public enum AlertPosition:Int {
    case center
    case bottom
}

public class TZAlertVC: UIControl {

    // MARK: - 对外配置属性
    /// 外部传入的自定义内容视图（核心）
    private var customContentView: UIView!
    
    /// 弹窗容器最大宽度（中间弹窗默认300，底部弹窗默认屏幕宽度）
    private var maxContainerWidth: CGFloat = UIScreen.main.bounds.width
    
    /// 弹窗容器最大高度（默认屏幕高度的80%，避免弹窗超出屏幕）
    private var maxContainerHeight: CGFloat = UIScreen.main.bounds.height * 0.8
    
    /// 弹窗容器背景色（默认白色）
    private var containerBgColor: UIColor = .white {
        didSet { containerView.backgroundColor = containerBgColor }
    }
    
    /// 弹窗容器圆角（默认12，底部弹窗默认仅顶部圆角16）
    private var containerCornerRadius: CGFloat = 12 {
        didSet {
            containerView.layer.cornerRadius = containerCornerRadius
            if position == .bottom {
                containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }
    
    /// 点击遮罩是否关闭弹窗（默认true）
    public var isDismissOnMaskTap: Bool = true
    
    /// 弹窗消失回调（外部可监听弹窗关闭事件）
    private var dismissHandler: (() -> Void)?
    
    private var containerHeight:NSLayoutConstraint?
    private var containerWidth:NSLayoutConstraint?
    
    // MARK: - 私有UI组件
    /// 背景遮罩
    private let maskview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 弹窗容器（承载外部传入的customContentView）
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 弹出位置
    private let position: AlertPosition
    // MARK: - 初始化方法
    /// 核心初始化：传入弹出位置 + 自定义内容视图
    private init(position: AlertPosition, customContentView: UIView) {
        self.position = position
        super.init(frame: UIScreen.main.bounds)
        
        // 初始化默认尺寸
        if position == .center {
            maxContainerWidth = 300 // 中间弹窗默认最大宽度300
        }
        // 设置自定义内容视图
        self.customContentView = customContentView
        setupCustomContentView()
        // 基础UI搭建
        setupBaseUI()
        setupConstraints()
        setupEvents()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 基础UI搭建
    private func setupBaseUI() {
        // 添加遮罩和容器
        addSubview(maskview)
        addSubview(containerView)
        
        // 底部弹窗默认样式
        if position == .bottom {
            containerView.layer.cornerRadius = 16
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        maskview.frame = bounds // 遮罩铺满屏幕
    }
    
    // MARK: - 自定义内容视图布局
    private func setupCustomContentView() {
        guard customContentView != nil else { return }
        
        // 添加自定义视图到容器，关闭自动布局转换
        containerView.addSubview(customContentView)
        customContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 自定义视图填充整个容器（关键：让外部视图决定容器尺寸）
        NSLayoutConstraint.activate([
            customContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            customContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            customContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            customContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: - 容器约束（核心：适配不同弹出位置）
    private func setupConstraints() {
//        let safeArea = UIApplication.shared.keyWindow?.safeAreaLayoutGuide
        let screenWidth = UIScreen.main.bounds.width
        self.containerWidth = containerView.widthAnchor.constraint(equalToConstant: maxContainerWidth)
        self.containerHeight = containerView.heightAnchor.constraint(equalToConstant: maxContainerHeight)
        NSLayoutConstraint.activate([
            // 容器宽度约束：不超过最大宽度，且不小于0
//            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: maxContainerWidth),
//            containerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
//
//            // 容器高度约束：不超过最大高度，且不小于0
//            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxContainerHeight),
//            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            containerWidth!,
            containerHeight!,
            
            // 水平居中
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // 垂直约束：区分弹出位置
            position == .center ?
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor) :
                containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 底部弹窗特殊处理：宽度默认全屏（可通过maxContainerWidth修改）
        if position == .bottom {
            containerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        }
    }
    
    // MARK: - 事件绑定
    private func setupEvents() {
        // 遮罩点击事件
        let maskTap = UITapGestureRecognizer(target: self, action: #selector(maskTapped))
        maskview.addGestureRecognizer(maskTap)
    }
    
    // MARK: - 事件处理
    @objc private func maskTapped() {
        guard isDismissOnMaskTap else { return }
        dismiss()
    }
    
    // MARK: - 弹出/消失动画（保留原有流畅动画）
    /// 弹出Alert
    private func show() {
        guard let keyWindow = UIApplication.shared.keyWindow, customContentView != nil else {
            debugPrint("⚠️ 自定义内容视图不能为空！")
            return
        }
        
        keyWindow.addSubview(self)
        
        // 动画前初始状态
        if position == .center {
            containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } else {
            containerView.transform = CGAffineTransform(translationX: 0, y: maxContainerHeight)
        }
        containerHeight?.constant = maxContainerHeight
        // 执行弹出动画
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.maskview.alpha = 1.0
            self.containerView.alpha = 1.0
            self.containerView.transform = .identity
        }
    }
    
    /// 消失Alert
    public func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {[weak self] in
            guard let self = self else { return }
            self.maskview.alpha = 0.0
            self.containerView.alpha = 0.0
            
            if self.position == .center {
                self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } else {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: self.maxContainerHeight)
            }
        } completion: {[weak self] _ in
            guard let self = self, let dismissHandler = dismissHandler else { return }
            self.removeFromSuperview()
            dismissHandler() // 回调消失事件
        }
    }
}

extension TZAlertVC {
    /// 快速创建自定义Alert
    public static func showAlert(with customView: UIView,
                                 position:AlertPosition,
                                 maxWidth:CGFloat = 300,
                                 maxHeight:CGFloat = UIScreen.main.bounds.height * 0.8,
                                 dismissHandler:(()->Void)?=nil) -> TZAlertVC {
        let alert = TZAlertVC(position: position, customContentView: customView)
        alert.maxContainerWidth = maxWidth
        alert.maxContainerHeight = maxHeight
        alert.dismissHandler = dismissHandler
        alert.show()
        return alert
    }
}
