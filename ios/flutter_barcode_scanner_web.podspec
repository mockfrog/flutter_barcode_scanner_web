#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_barcode_scanner_web'
  s.version          = '0.0.2'
  s.summary          = 'No-op implementation of flutter_barcode_scanner_web plugin to avoid build issues on iOS'
  s.description      = <<-DESC
temp fake flutter_barcode_scanner plugin
                       DESC
  s.homepage         = 'https://github.com/mockfrog/flutter_barcode_scanner_web'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Timo Bußhaus' => 'mockfrogger@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{swift,h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
end