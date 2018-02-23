#
#  Be sure to run `pod spec lint HPLoaders.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HPLoaders"
  s.version      = "1.0.0"
  s.summary      = "Collection of custom loaders powered by SpriteKit"

  s.homepage     = "https://facebook.com/HPanhans"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Fri3ndlyGerman" => "henrikpanhans@icloud.com" }
  s.social_media_url   = "https://twitter.com/HPanhans"

  s.ios.deployment_target = "9.0"

  s.source       = { :git => 'https://github.com/Fri3ndlyGerman/HPLoaders.git', :tag => "1.0.0" }

  s.source_files = "HPLoaders", "*.{plist,h,swift}"
  s.swift_version = "4.0"
  s.requires_arc = true
  s.framework  = "SpriteKit"

end
