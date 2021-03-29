Pod::Spec.new do |spec|
  spec.name         = "LYBProgressHUD"
  spec.version      = "1.1.0"
  spec.summary      = "HUD"
  spec.description  = <<-DESC
  一款OSX平台上简洁易用的HUD组件
                   DESC
                   
  spec.homepage     = "https://github.com/liyb93/LYBProgressHUD"
  spec.license      = "MIT"
  spec.author             = { "liyb" => "libcm93@gmail.com" }

  spec.platform     = :osx
  spec.platform     = :osx, "10.11"
  spec.osx.deployment_target = '10.11'

  spec.swift_version = "5.0"
  
  spec.source       = { :git => "https://github.com/liyb93/LYBProgressHUD.git", :tag => spec.version }

  spec.source_files  = "LYBProgressHUD", "Source/*.swift"
  spec.exclude_files = "LYBProgressHUD/Source"
end
