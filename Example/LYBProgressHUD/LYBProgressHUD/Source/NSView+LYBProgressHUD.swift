//
//  NSView+LYBProgressHUD.swift
//  LBProgressHUD
//
//  Created by mac on 2022/8/4.
//

import Cocoa

public protocol NamespaceCompatible {
    associatedtype CompatibleType
    var lyb: CompatibleType { get }
    static var lyb: CompatibleType.Type { get }
}

public struct Namespace<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

public extension NamespaceCompatible {
    var lyb: Namespace<Self> {
        return Namespace(self)
    }

    static var lyb: Namespace<Self>.Type {
        return Namespace.self
    }
}

extension NSView: NamespaceCompatible { }

public typealias StyleHandler = (LYBProgressHUDStyle)->()
public extension Namespace where Base: NSView {
    
    @discardableResult
    func showMessage(_ message: String) -> Namespace {
        return showHUD(message) { style in
            style.mode = .text
        }
    }
    
    @discardableResult
    func showIndicator() -> Namespace {
        return showHUD { style in
            style.mode = .indicator
        }
    }
    
    @discardableResult
    func showHUD(_ message: String? = nil, style: StyleHandler? = nil) -> Namespace {
        let hudStyle = LYBProgressHUDStyle.init()
        style?(hudStyle)
        LYBProgressHUD.show(in: base, message: message, style: hudStyle)
        return self
    }
    
    @discardableResult
    func dismiss(delay: TimeInterval = 0, completionHandler: CompletionHandler? = nil) -> Namespace {
        LYBProgressHUD.dismiss(in: base, after: delay, completionHandler: completionHandler)
        return self
    }
}
