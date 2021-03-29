//
//  LYBProgressHUD.swift
//  LYBProgressHUD
//
//  Created by liyb on 2020/11/13.
//

import Cocoa

/// 'default'与'indicator'样式最小宽度
fileprivate let LYBProgressHUDContentMinWidth: CGFloat = 150.0
/// 'default'与'indicator'样式最小高度
fileprivate let LYBProgressHUDContentMinHeight: CGFloat = 150.0
/// 'text'样式最小高度
fileprivate let LYBProgressHUDContentTextMinHeight: CGFloat = 45.0
/// indicator宽高
fileprivate let LYBProgressHUDIndicatorWH: CGFloat = 50.0
/// indicator与text间距
fileprivate let LYBProgressHUDSpacing: CGFloat = 15.0

class LYBProgressHUDMaskView: NSView {
    /// 阻止事件穿透
    override func mouseDown(with event: NSEvent) {}
}

public class LYBProgressHUDStyle: NSObject {
    // 显示样式
    public enum Mode {
        case `default`    // 指示器与文本
        case text   // 文本
        case indicator  // 指示器
    }
    
    // 显示位置
    public enum Position {
        case center // 居中
        case top    // 居顶
        case bottom // 居下
        case left   // 居左
        case right  // 居右
    }
    
    public var mode: Mode = .default
    public var position: Position = .center
    public var backgroundColor: NSColor = NSColor.black.withAlphaComponent(0.75)
    public var textColor: NSColor = .white
    public var textFont: NSFont = .systemFont(ofSize: 15)
    public var indicatorColor: NSColor = .white
    
    init(_ mode: Mode = .default, position: Position = .center, backgroundColor: NSColor = NSColor.black.withAlphaComponent(0.75), textColor: NSColor = .white, textFont: NSFont = .systemFont(ofSize: 15), indicatorColor: NSColor = .white) {
        super.init()
        self.mode = mode
        self.position = position
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textFont = textFont
        self.indicatorColor = indicatorColor
    }
}

public class LYBProgressHUD: NSView {
    
    private var maskView: NSView!
    private var contentView: NSView!
    private var textLabel: NSTextField?
    private var indicatorActivity: LYBProgressIndicator?
    private var superView: NSView!
    private var style: LYBProgressHUDStyle!
    private var message: String?
    
    public init(in view: NSView, message: String? = nil, style: LYBProgressHUDStyle? = nil) {
        super.init(frame: view.bounds)
        superView = view
        self.style = style ?? LYBProgressHUDStyle.init()
        self.message = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 清除子控件
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        // 遮罩
        maskView = LYBProgressHUDMaskView.init(frame: bounds)
        
        var contentSize: CGSize = CGSize.init(width: LYBProgressHUDContentMinWidth, height: LYBProgressHUDContentMinHeight)
        switch style.mode {
        case .default:  // 指示器与文本
            if let text = message { // 有文本
                let maxWidth = superView.bounds.width - LYBProgressHUDSpacing * 2
                let maxHeight = superView.bounds.height - LYBProgressHUDIndicatorWH - LYBProgressHUDSpacing * 3
                let size = (text as NSString).boundingRect(with: CGSize.init(width: maxWidth, height: maxHeight), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: style.textFont]).size
                
                let contentWidth = max(size.width + LYBProgressHUDSpacing * 2, LYBProgressHUDContentMinWidth)
                let contentHeight = max(size.height + LYBProgressHUDSpacing * 3 + LYBProgressHUDIndicatorWH, LYBProgressHUDContentMinHeight)
                contentSize = CGSize.init(width: contentWidth , height: contentHeight)
                
                let indicatorX = (contentWidth / 2.0) - (LYBProgressHUDIndicatorWH / 2.0)
                let indicatorY = (contentHeight / 2.0) - (LYBProgressHUDIndicatorWH / 2.0) + (size.height / 2.0)
                indicatorActivity = createIndicator(with: .init(x: indicatorX, y: indicatorY, width: LYBProgressHUDIndicatorWH, height: LYBProgressHUDIndicatorWH))
                
                let labelY = indicatorY - size.height - LYBProgressHUDSpacing
                let labelWidht = max(size.width + 10, contentWidth - LYBProgressHUDSpacing * 2)
                textLabel = createLabel(with: .init(x: LYBProgressHUDSpacing - 5, y: labelY, width: labelWidht, height: size.height), text: text)
            } else {    // 无文本
                let x = (contentSize.width / 2.0) - (LYBProgressHUDIndicatorWH / 2.0)
                let y = (contentSize.height / 2.0) - (LYBProgressHUDIndicatorWH / 2.0)
                indicatorActivity = createIndicator(with: .init(x: x, y: y, width: LYBProgressHUDIndicatorWH, height: LYBProgressHUDIndicatorWH))
                indicatorActivity?.color = .white
            }
        case .indicator:    // 指示器
            let x = (contentSize.width / 2.0) - (LYBProgressHUDIndicatorWH / 2.0)
            let y = contentSize.height / 2.0 - (LYBProgressHUDIndicatorWH / 2.0)
            indicatorActivity = createIndicator(with: .init(x: x, y: y, width: LYBProgressHUDIndicatorWH, height: LYBProgressHUDIndicatorWH))
        case .text: // 文本
            if let text = message {
                let maxWidth = superView.bounds.width - LYBProgressHUDSpacing * 2
                let maxHeight = superView.bounds.height - LYBProgressHUDSpacing * 2
                let size = (text as NSString).boundingRect(with: CGSize.init(width: maxWidth, height: maxHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: style.textFont]).size
                
                let contentWidth = size.width + LYBProgressHUDSpacing * 2
                let contentHeight = max(size.height + LYBProgressHUDSpacing * 2, LYBProgressHUDContentTextMinHeight)
                contentSize = CGSize.init(width: contentWidth , height: contentHeight)
                textLabel = createLabel(with: .init(x: LYBProgressHUDSpacing - 5, y: LYBProgressHUDSpacing, width: size.width + 10, height: contentHeight - LYBProgressHUDSpacing * 2), text: text)
            } else {
                fatalError("message不可为nil")
            }
        }
        
        // 显示位置
        var x: CGFloat, y: CGFloat;
        switch style.position {
        case .center:
            x = superView.bounds.width / 2.0 - (contentSize.width / 2.0)
            y = superView.bounds.height / 2.0 - (contentSize.height / 2.0)
        case .top:
            x = superView.bounds.width / 2.0 - (contentSize.width / 2.0)
            y = superView.bounds.height - contentSize.height - LYBProgressHUDSpacing
        case .bottom:
            x = superView.bounds.width / 2.0 - (contentSize.width / 2.0)
            y = LYBProgressHUDSpacing
        case .left:
            x = LYBProgressHUDSpacing
            y = superView.bounds.height / 2.0 - (contentSize.height / 2.0)
        case .right:
            x = superView.bounds.width - contentSize.width - LYBProgressHUDSpacing
            y = superView.bounds.height / 2.0 - (contentSize.height / 2.0)
        }
        
        contentView = NSView.init(frame: CGRect.init(origin: CGPoint.init(x: x, y: y), size: contentSize))
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = style.backgroundColor.cgColor
        contentView.layer?.cornerRadius = LYBProgressHUDSpacing
        contentView.layer?.masksToBounds = true
        
        addSubview(maskView)
        addSubview(contentView)
        
        if let indicator = indicatorActivity {
            contentView.addSubview(indicator)
        }
        if let label = textLabel {
            contentView.addSubview(label)
        }
        // 监听superview尺寸变化
        superView.window?.delegate = self
    }

    private func createIndicator(with frame: CGRect) -> LYBProgressIndicator {
        let indicator = LYBProgressIndicator.init(frame: frame)
        indicator.color = style.indicatorColor
        return indicator
    }
    
    private func createLabel(with frame: CGRect, text: String) -> NSTextField {
        let label = NSTextField.init(frame: frame)
        label.stringValue = text
        label.isEditable = false
        label.alignment = .center
        label.maximumNumberOfLines = 0
        label.textColor = style.textColor
        label.font = style.textFont
        // 背景色透明
        label.isBordered = false
        label.drawsBackground = false
        label.backgroundColor = .clear
        return label
    }
    
    public func show() {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.3
            superView.addSubview(self)
        } completionHandler: {
            self.indicatorActivity?.startAnimation(nil)
        }
    }
    
    public func dismiss(after delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            NSAnimationContext.runAnimationGroup { (context) in
                context.duration = 0.3
                self.removeFromSuperview()
            }
        }
    }
    
    public class func show(in view: NSView, message: String? = nil, style: LYBProgressHUDStyle? = nil) {
        let hud = LYBProgressHUD.init(in: view, message: message, style: style)
        hud.show()
    }
    
    public class func dismiss(in view: NSView, after delay: TimeInterval = 0) {
        view.subviews.filter({$0 is LYBProgressHUD}).forEach { (view) in
            (view as? LYBProgressHUD)?.dismiss(after: delay)
        }
    }
}

extension LYBProgressHUD: NSWindowDelegate {
    public func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        // 设置最小尺寸
        let width = contentView.frame.width + LYBProgressHUDSpacing * 4
        let height = contentView.frame.height + LYBProgressHUDSpacing * 4
        if frameSize.width < width && frameSize.height >= height {
            return CGSize.init(width: width, height: frameSize.height)
        } else if frameSize.width < width && frameSize.height < height {
            return CGSize.init(width: width, height: height)
        } else if frameSize.width >= width && frameSize.height < height {
            return CGSize.init(width: frameSize.width, height: height)
        }
        return frameSize
    }
    
    public func windowDidResize(_ notification: Notification) {
        // hud居中显示
        let x = superView.bounds.width / 2.0 - (contentView.frame.width / 2.0)
        let y = superView.bounds.height / 2.0 - (contentView.frame.height / 2.0)
        let width = contentView.frame.width
        let height = contentView.frame.height
        contentView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        frame = superView.bounds
    }
}
