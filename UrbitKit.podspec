#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                    = "UrbitKit"
  s.version                 = "0.1.0"
  s.summary                 = "Swift client for Urbit."
  s.homepage                = "https://github.com/dclelland/UrbitKit"
  s.license                 = { :type => 'MIT' }
  s.author                  = { "Daniel Clelland" => "daniel.clelland@gmail.com" }
  s.source                  = { :git => "https://github.com/dclelland/UrbitKit.git", :tag => "0.1.0" }
  s.platform                = :osx, '10.15'
  s.swift_version           = '5.0'
  
  s.osx.deployment_target = '10.15'
  s.osx.source_files      = 'Sources/**/*.swift'
  s.osx.resource_bundle   = { 'UrbitKit' => 'Resources/*' }
end
