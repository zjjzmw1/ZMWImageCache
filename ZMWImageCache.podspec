Pod::Spec.new do |s|

s.name             = "ZMWImageCache"

s.version          = "1.1.0"

s.summary          = "获取网络图片并缓存（默认带内存缓存，可以用不带的方法）"

s.description      = <<-DESC
 "获取网络图片并缓存（默认带内存缓存，可以用不带的方法）"
DESC

s.homepage         = "https://github.com/zjjzmw1/ZMWImageCache"
s.license          = "MIT"
s.author           = { "张明炜" => "zjjzmw1@163.com" }

s.source           = { :git => "https://github.com/zjjzmw1/ZMWImageCache.git", :tag => s.version.to_s }
s.platform     = :ios, "7.0"

s.requires_arc = true

s.source_files = "Classes/*"

s.frameworks = "Foundation", "CoreGraphics", "UIKit"

end