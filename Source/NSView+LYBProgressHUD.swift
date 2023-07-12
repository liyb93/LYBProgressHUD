//
//  NSView+LYBProgressHUD.swift
//  LBProgressHUD
//
//  Created by mac on 2022/8/4.
//

import Cocoa

public protocol LYBHUDCompatible {
    associatedtype CompatibleType
    var lyb: CompatibleType { get }
    static var lyb: CompatibleType.Type { get }
}

public struct LYBHUD<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public extension LYBHUDCompatible {
    var lyb: LYBHUD<Self> {
        return LYBHUD(self)
    }

    static var lyb: LYBHUD<Self>.Type {
        return LYBHUD.self
    }
}

extension NSView: LYBHUDCompatible { }

public typealias StyleHandler = (LYBProgressHUDStyle)->()
public extension LYBHUD where Base: NSView {
    
    @discardableResult
    func showMessage(_ message: String) -> LYBHUD {
        return showHUD(message) { style in
            style.mode = .text
        }
    }
    
    @discardableResult
    func showIndicator() -> LYBHUD {
        return showHUD { style in
            style.mode = .indicator
        }
    }
    
    @discardableResult
    func showCustom(view: NSView, message: String? = nil) -> LYBHUD {
        return showHUD(message) { style in
            style.mode = .custom(view)
        }
    }
    
    @discardableResult
    func showHUD(_ message: String? = nil, style: StyleHandler? = nil) -> LYBHUD {
        let hudStyle = LYBProgressHUDStyle.init()
        style?(hudStyle)
        LYBProgressHUD.show(in: base, message: message, style: hudStyle)
        return self
    }
    
    @discardableResult
    func dismiss(delay: TimeInterval = 0, completionHandler: CompletionHandler? = nil) -> LYBHUD {
        LYBProgressHUD.dismiss(in: base, after: delay, completionHandler: completionHandler)
        return self
    }
}
