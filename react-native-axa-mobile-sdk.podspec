# react-native-axa-mobile-sdk.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = 'react-native-axa-mobile-sdk'
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = package["description"]
  s.license      = package['license']


  s.homepage     = package["homepage"]
  s.authors      = package['author']
  s.platform     = :ios, '9.0'

  s.source       = { :git => "https://github.com/CA-Application-Performance-Management/ReactNativeAxaMobileSdk.git", :tag => "#{s.version}" }
  s.source_files = 'ios/*.{h,c,cc,cpp,m,mm,swift}'

  s.dependency "React"
  s.dependency 'CAMobileAppAnalytics', '22.3.2-beta.1.0'

  s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'

  s.requires_arc = true
  s.ios.deployment_target = '9.0'

  # s.public_header_files = 'ios/CAMobileAppAnalytics/*.h'
  # s.resources = 'ios/CAMobileAppAnalytics/*.js'
  # s.vendored_libraries = 'ios/CAMobileAppAnalytics/*.a'
  
  # s.libraries = 'c++', 'z', 'sqlite3'
  # s.frameworks = 'CoreLocation', 'SystemConfiguration', 'Foundation', 'UIKit', 'CoreGraphics', 'Security', 'CoreTelephony', 'WebKit'

end

