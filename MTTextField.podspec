#
# Be sure to run `pod lib lint MTTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MTTextField'
  s.version          = '0.1.1'
  s.summary          = 'A short description of MTTextField.'
  s.description      = 'A TextField package'

  s.homepage         = 'https://github.com/wangyutao0424/MTTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangyutao0424' => 'wangyutao0424@163.com' }
  s.source           = { :git => 'https://github.com/wangyutao0424/MTTextField.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_versions = ['5.0']

  s.source_files = 'MTTextField/Classes/**/*'
  # s.dependency 'AFNetworking', '~> 2.3'
end
