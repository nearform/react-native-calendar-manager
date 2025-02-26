Pod::Spec.new do |s|
  s.name         = "CalendarManager"
  s.version      = "0.1.0"
  s.summary      = "Extension used to manipulate calendars with React Native"

  s.homepage     = "https://nearform.com/"
  s.license      = { :type => "MIT" }
  s.author       = { "Matteo Pietro Dazzi" => "matteo.pietro.dazzi@nearform.com" }
  s.platforms    = { :ios => "8.0" }
  s.source       = { :git => "https://github.com/ilteoood/react-native-calendar-manager.git", :tag => "0.1" }

  s.source_files = '**/*.{h,m}'

  s.dependency 'React'
end
