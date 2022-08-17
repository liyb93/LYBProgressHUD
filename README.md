# LYBProgressHUD

<p align="center">
<a href="https://github.com/liyb93/LYBProgressHUD.git"><img src="https://img.shields.io/badge/platform-osx-lightgrey"></a>
<a href="https://github.com/liyb93/LYBProgressHUD.git"><img src="https://img.shields.io/badge/language-swift%205.x-orange"></a>
<a href="https://raw.githubusercontent.com/liyb93/LYBProgressHUD/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange"></a>
</p>

LYBProgressHUD是一款在OSX上简洁易用的HUD组件。

## 预览

![preview](https://raw.githubusercontent.com/liyb93/LYBProgressHUD/master/preview.gif)

## 功能

- 三种提示样式
- 自定义属性
- 简洁API，方便使用
- 阻止事件穿透，防止父视图事件穿透
- 根据父视图尺寸改变frame，防止父视图拉伸，hud位置不变
- 自定义显示位置

## 使用

- 直接调用

  ```swift
  /*
  	view:	父视图
  	message:	显示信息
  	style: hud样式描述信息
  		mode: hud样式
  		position: 显示位置
  		backgroundColor: hud背景色
  		textColor:	文本颜色
  		textFont: 文本字体
  		indicatorColor:	指示器颜色
  */
  LYBProgressHUD.show(in: view, message: "加载成功", style: LYBProgressHUDStyle.init(.text))
  或者
  view.lyb.showHUD("加载成功") { style in
    style.mode = .text
    style.textFont = NSFont.boldSystemFont(ofSize: 20)
    style.textColor = .orange
  }
  /*
  	view: 父视图
  	after:	延迟移除，默认为0
  */
  LYBProgressHUD.dismiss(in: view, after: 3)
  或者
  view.dismiss(3)
  ```

- 自定义属性

  ```swift
  let style = LYBProgressHUDStyle.init()
  // hud样式
  style.mode = .text
  // hud显示位置
  style.position = .top
  // 背景色
  style.backgroundColor = .white
  // 文本颜色
  style.textColor = .black
  // 文本字体
  style.textFont = NSFont.boldSystemFont(ofSize: 20)
  // 指示器颜色
  style.indicatorColor = .black
  let hud = LYBProgressHUD.init(in: view, message: "加载中。。。", style: style)
  hud.show()
  hud.dismiss(after: 3)
  或者
  view.lyb.showHUD("加载成功") { style in
    style.mode = .text
    style.textFont = NSFont.boldSystemFont(ofSize: 20)
    style.textColor = .orange
  }.dismiss(3)
  ```

## 安装

### Cocoapods

1. 将LYBProgressHUD添加到你项目的podfile中 `pod 'LYBProgressHUD'`
2. 运行`pod install`进行安装
3. 在需要的地方导入`import LYBProgressHUD`

## 更新记录

### v1.1.2

- 增加`text`和`indicator`mode快捷调用方式
- 开放更多自定义属性

### v1.1.1
- 增加链式调用方式

### v1.1.0

- 修改实现方案，自定义属性单独抽出
- 增加显示位置

### v1.0.0

- 三种提示样式
- 自定义属性

## 参考

[YRKSpinningProgressIndicator](https://github.com/kelan/YRKSpinningProgressIndicator)

