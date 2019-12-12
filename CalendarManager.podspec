require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "CalendarManager"
  s.version      = package["version"]
  s.summary      = "Native Shoutem extension used for access to Firebase SDK"

  s.homepage     = "http://www.shoutem.com"
  s.license      = { :type => "BSD" }
  s.author       = { "Vladimir Vdović" => "vlad@definitely-not-vlad.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/shoutem/react-native-calendar-manager.git", :tag => "1.0" }

  s.source_files = 'CalendarManager/CalendarManager.{h,m}'

  s.dependency 'React'
end
