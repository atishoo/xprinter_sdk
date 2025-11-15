Pod::Spec.new do |s|
  s.name             = 'xprinter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'xprinter的flutter版本sdk'
  s.description      = <<-DESC
xprinter的flutter版本sdk
  DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency       'Flutter'
  s.platform         = :ios, '12.0'

  # 只是告诉 CocoaPods 这个文件要被保留，不用做别的处理
  s.preserve_paths = 'Classes/PrinterSDK/libPrinterSDK.a'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'OTHER_LDFLAGS[sdk=iphoneos*]' => '$(inherited) -l"PrinterSDK"',
    'LIBRARY_SEARCH_PATHS[sdk=iphoneos*]' => '"${PODS_TARGET_SRCROOT}/Classes/PrinterSDK"',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
end
