Pod::Spec.new do |s|
  s.name           = "FSUpdateMe"
  s.version        = "0.0.1"
  s.summary        = "An updater for enterpsirse OTA apps. "
  s.homepage       = "https://github.com/fsaint/FSUpateMe"
  s.license        = 'MIT'
  s.author         = { "Felipe Saint-Jean" => "fsaint@gmail.com" }
  s.platform       = :ios, '6.0'
  s.source         = { :git => "https://github.com/fsaint/FSUpateMe.git" }
  s.source_files   = 'Classes/*.{h,m}'
  s.requires_arc   = true
  s.dependency 'AFNetworking'
end
