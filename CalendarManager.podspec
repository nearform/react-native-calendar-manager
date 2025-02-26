package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "CalendarManager"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']
  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.source       = { :git => package['repository']['url'], :tag => s.version }

  s.platforms       = { ios: '13.4' }
  s.source_files = '**/*.{h,m}'

  s.dependency "React"
end
