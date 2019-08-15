#
# Be sure to run `pod lib lint ZZBarrage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZZBarrage'
  s.version          = '0.1.1'
  s.summary          = 'A Bullet Curtain Container Supporting Floating Animation Clicks.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A Bullet Curtain Container Supporting Floating Animation Clicks, You can define various items.'

  s.homepage         = 'https://github.com/delete-x/ZZBarrage'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'delete-x' => 'coder_rqb@163.com' }
  s.source           = { :git => 'https://github.com/delete-x/ZZBarrage.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZZBarrage/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZZBarrage' => ['ZZBarrage/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
