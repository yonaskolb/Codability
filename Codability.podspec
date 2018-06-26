Pod::Spec.new do |s|
	s.name         = 'Codability'
	s.version      = '0.2.1'
	s.swift_version = '4.1'
	s.summary      = 'Useful helpers for working with Codable types in Swift'
	s.homepage     = 'http://github.com/yonaskolb/Codability'
	s.license      = { :type => 'MIT', :file => 'LICENSE' }
	s.author       = { 'Yonas Kolb' => 'yonas4596@hotmail.com' }
	s.social_media_url   = 'https://twitter.com/yonaskolb'

	s.ios.deployment_target = '9.0'
	s.osx.deployment_target = '10.9'
	s.tvos.deployment_target = '9.0'
	s.watchos.deployment_target = '3.0'

    s.source       = { :git => 'https://github.com/yonaskolb/Codability.git', :tag => s.version.to_s }
	s.source_files  = 'Sources/**/*.swift'
	s.frameworks  = 'Foundation'
end
