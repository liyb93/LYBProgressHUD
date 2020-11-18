//
//  ViewController.swift
//  LYBProgressHUD
//
//  Created by liyb on 2020/11/13.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func defaultClickHandler(_ sender: Any) {
        LYBProgressHUD.show(in: view, message: "Loding...")
        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func indicatorClickHandler(_ sender: Any) {
        LYBProgressHUD.show(in: view, style: .indicator)
        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func textClickHandler(_ sender: Any) {
        LYBProgressHUD.show(in: view, message: "加载成功", style: .text)
        LYBProgressHUD.dismiss(in: view, after: 3)
    }
    
    @IBAction func textColorClickHandler(_ sender: Any) {
        let hud = LYBProgressHUD.init(in: view, style: .text, message: "加载中。。。")
        hud.textColor = .orange
        hud.show()
        hud.dismiss(after: 3)
    }
    
    @IBAction func textFontClickHandler(_ sender: Any) {
        let hud = LYBProgressHUD.init(in: view, style: .text, message: "加载中。。。")
        hud.textFont = NSFont.init(name: "HannotateSC-W5", size: 20) ?? NSFont.boldSystemFont(ofSize: 20)
        hud.show()
        hud.dismiss(after: 3)
    }
    
    @IBAction func backgroundClickHandler(_ sender: Any) {
        let hud = LYBProgressHUD.init(in: view, style: .text, message: "加载中。。。")
        hud.contentBackgroundColor = .orange
        hud.show()
        hud.dismiss(after: 3)
    }
    
    @IBAction func indicatorColorClickHandler(_ sender: Any) {
        let hud = LYBProgressHUD.init(in: view, style: .indicator)
        hud.indicatorColor = .orange
        hud.show()
        hud.dismiss(after: 3)
    }
}

