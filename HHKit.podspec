Pod::Spec.new do |s|
  s.name         = 'HHKit'
  s.summary      = 'A collection of iOS components.'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'hjn' => '834961571@qq.com' }
  s.social_media_url = 'https://www.jianshu.com/u/cf118fbcc938'
  s.homepage     = 'https://github.com/HApple/HHKit'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/HApple/HHKit.git', :tag => s.version }
  
  s.requires_arc = true
  s.source_files = 'HHKit/HHKit/**/*.{h,m}'
  s.public_header_files = 'HHKit/HHKit/**/*.{h}'
  
  #二级目录
  s.subspec 'Tool' do |tool|
    tool.source_files = 'HHKit/HHKit/Tool/*.{h,m}'
    end
    
  s.subspec 'Util' do |util|
    util.source_files = 'HHKit/HHKit/Util/*.{h,m}'
    end


  #s.libraries = 'z', 'sqlite3'
  s.frameworks = 'UIKit', 'CoreFoundation', 'CoreText', 'CoreGraphics', 'CoreImage', 'QuartzCore', 'ImageIO', 'AssetsLibrary', 'Accelerate', 'MobileCoreServices', 'SystemConfiguration'
  #s.ios.vendored_frameworks = 'Vendor/WebP.framework'
  
  s.dependency 'YBModelFile'
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'YYKit'
end
