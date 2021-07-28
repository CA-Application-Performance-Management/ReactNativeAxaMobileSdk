# react-native-axa-mobile-sdk.podspec

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-axa-mobile-sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  CA App Experience Analytic native SDK's react native supplement for using custom metrics
                   DESC
  s.homepage     = "https://techdocs.broadcom.com/content/broadcom/techdocs/us/en/ca-enterprise-software/it-operations-management/app-experience-analytics-saas/SaaS/configuring/collect-data-from-ios-applications.html"
  # brief license entry:
  s.license    = { :type => "Apache License 2.0", :file => "LICENSE" }
  s.authors      = { "CA Technologies (A Broadcom Company)" => "www.broadcom.com" }
  s.source       = { :git => "https://github.com/CA-Application-Performance-Management/ReactNativeAxaMobileSdk.git", :tag => "#{s.version}" }

  s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'

  s.requires_arc = true
  s.platform       = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'ios/*.{h,c,cc,cpp,m,mm,swift}'
  # s.public_header_files = 'ios/CAMobileAppAnalytics/*.h'
  # s.resources = 'ios/CAMobileAppAnalytics/*.js'
  # s.vendored_libraries = 'ios/CAMobileAppAnalytics/*.a'
  
  # s.libraries = 'c++', 'z', 'sqlite3'
  # s.frameworks = 'CoreLocation', 'SystemConfiguration', 'Foundation', 'UIKit', 'CoreGraphics', 'Security', 'CoreTelephony', 'WebKit', 'WatchConnectivity'

  s.dependency "React"
  s.dependency 'CAMobileAppAnalytics'
  # ...
  # s.dependency "..."
end

