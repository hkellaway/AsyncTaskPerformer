Pod::Spec.new do |s|

  s.name             = "AsyncTaskPerformer"
  s.version          = "0.0.1"
  s.summary          = "Performs lists of asynchronous tasks"
  s.description      = "Performs lists of asynchronous tasks."
  s.homepage         = "https://github.com/hkellaway/AsyncTaskPerformer"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source           = { :git => "https://github.com/hkellaway/AsyncTaskPerformer.git", :tag => s.version.to_s }
  
  s.platforms     = { :ios => "12.0" }
  s.requires_arc = true
  s.source_files = "Sources/*.swift"

end
