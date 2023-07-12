//
//  ViewController.swift
//  LYBProgressHUD
//
//  Created by liyb on 2020/11/13.
//

import Cocoa
import LYBProgressHUD

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func customClickHandler(_ sender: Any) {
        let imageView = NSImageView()
        imageView.image = NSImage(named: "success")
        view.lyb.showCustom(view: imageView, message: "加载成功").dismiss(delay: 3)
    }
    
    @IBAction func defaultClickHandler(_ sender: Any) {
        view.lyb.showHUD("Loding...").dismiss(delay: 3)
//        LYBProgressHUD.show(in: view, message: "")
//        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func indicatorClickHandler(_ sender: Any) {
        view.lyb.showIndicator().dismiss(delay: 3)
//        LYBProgressHUD.show(in: view, style: LYBProgressHUDStyle.init(.indicator))
//        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func textClickHandler(_ sender: Any) {
        view.lyb.showMessage("加载成功").dismiss(delay: 3)
//        LYBProgressHUD.show(in: view, message: "加载成功", style: LYBProgressHUDStyle.init(.text, position: .top))
//        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func textColorClickHandler(_ sender: Any) {
        view.lyb.showHUD("加载中...") { style in
            style.mode = .text
            style.textColor = .orange
        }.dismiss(delay: 3)
//        let style = LYBProgressHUDStyle.init(.text, textColor: .orange)
//        let hud = LYBProgressHUD.init(in: view, message: "加载中。。。", style: style)
//        hud.show()
//        hud.dismiss(after: 3)
    }
    
    @IBAction func textFontClickHandler(_ sender: Any) {
        let textFont = NSFont.init(name: "HannotateSC-W5", size: 20) ?? NSFont.boldSystemFont(ofSize: 20)
        view.lyb.showHUD("加载中...") { style in
            style.mode = .text
            style.textFont = textFont
            style.textColor = .orange
        }.dismiss(delay: 3)
//        let style = LYBProgressHUDStyle.init(.text, textFont: textFont)
//        let hud = LYBProgressHUD.init(in: view, message: "加载中。。。", style: style)
//        hud.show()
//        hud.dismiss(after: 3)
    }
    
    @IBAction func backgroundClickHandler(_ sender: Any) {
        view.lyb.showHUD("加载中...") { style in
            style.mode = .text
            style.backgroundColor = .orange
        }.dismiss(delay: 3)
//        let style = LYBProgressHUDStyle.init(.text, backgroundColor: .orange)
//        let hud = LYBProgressHUD.init(in: view, message: "加载中。。。", style: style)
//        hud.show()
//        hud.dismiss(after: 3)
    }
    
    @IBAction func indicatorColorClickHandler(_ sender: Any) {
//        let style = LYBProgressHUDStyle.init(.indicator, indicatorColor: .orange)
//        let hud = LYBProgressHUD.init(in: view, style: style)
//        hud.show()
//        hud.dismiss(after: 3)
        view.lyb.showHUD { style in
            style.mode = .indicator
            style.indicatorColor = .orange
            style.hudSize = CGSize(width: 80, height: 80)
        }.dismiss(delay: 3)
    }
}

