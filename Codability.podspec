#
#  Be sure to run `pod spec lint Codability.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
	s.name         = "Codability"
	s.version      = "0.2.1"
	s.swift_version = "4.1"
	s.summary      = "Useful helpers for working with Codable types in Swift"
	s.homepage     = "http://github.com/yonaskolb/Codability"
	s.license      = { :type => "MIT", :file => "LICENSE" }
	s.author       = { "Yonas Kolb" => "yonas4596@hotmail.com" }
	s.social_media_url   = "https://twitter.com/yonaskolb"
	s.ios.deployment_target = "9.0"
	s.tvos.deployment_target = "9.0"
	s.source       = { :git => "https://github.com/yonaskolb/Codability.git", :tag => s.version.to_s }
	s.source_files  = "Sources/**/*.swift"
	s.frameworks  = "Foundation"
end
