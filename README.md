# LYBProgressHUD

<p align="center">
<a href="https://github.com/liyb93/LYBProgressHUD.git"><img src="https://img.shields.io/badge/platform-osx-lightgrey"></a>
<a href="https://github.com/liyb93/LYBProgressHUD.git"><img src="https://img.shields.io/badge/language-swift%205.x-orange"></a>
<a href="https://raw.githubusercontent.com/liyb93/LYBProgressHUD/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange"></a>
</p>

LYBProgressHUD是一款在OSX上简洁易用的HUD组件。

## 预览

![preview](https://raw.githubusercontent.com/liyb93/LYBProgressHUD/main/preview.gif)

## 功能

- 三种提示样式
- 自定义属性
- 简洁API，方便使用
- 阻止事件穿透，防止父视图事件穿透
- 根据父视图尺寸改变frame，防止父视图拉伸，hud位置不变

## 使用

- 直接调用

  ```swift
  /*
  	view:	父视图
  	message:	显示信息
  	style: 
  		default: 文本与指示器同时显示，message为nil时与indicator样式一样
  		text:	只有文本显示，此样式message为必传参数
  		indicator:	只有指示器显示
  */
  LYBProgressHUD.show(in: view, message: "加载成功", style: .text)
  /*
  	view: 父视图
  	after:	延迟移除，默认为0
  */
  LYBProgressHUD.dismiss(in: view, after: 3)
  ```

- 自定义属性

  ```swift
  let hud = LYBProgressHUD.init(in: view, style: .text, message: "加载中。。。")
  // 文本颜色
  hud.textColor = .black
  // 背景色
  hud.contentBackgroundColor = .white
  // 指示器颜色
  hud.indicatorColor = .black
  // 文本字体
  hud.textFont = NSFont.boldSystemFont(ofSize: 20)
  hud.show()
  hud.dismiss(after: 3)
  ```

## 安装

### Cocoapods

1. 将LYBProgressHUD添加到你项目的podfile中 `pod 'LYBProgressHUD'`
2. 运行`pod install`进行安装
3. 在需要的地方导入`import LYBProgressHUD`

## 参考

[YRKSpinningProgressIndicator](https://github.com/kelan/YRKSpinningProgressIndicator)

