Pod::Spec.new do |s|
  s.name             = 'WTAuthorizationTool'
  s.version          = '0.1.0'
  s.summary          = 'Request camera/album/addressBook Authorization Tool.'

  s.description      = <<-DESC
You can use WTAuthorizationTool to Request camera/album/addressBook Authorization.
                       DESC

  s.homepage         = 'https://github.com/wusuowei/WTAuthorizationTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wentianen' => '1206860151@qq.com' }
  s.source           = { :git => 'https://github.com/wusuowei/WTAuthorizationTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'WTAuthorizationTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WTAuthorizationTool' => ['WTAuthorizationTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
