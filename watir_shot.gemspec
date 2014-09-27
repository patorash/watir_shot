$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "watir_shot/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "watir_shot"
  s.version     = WatirShot::VERSION
  s.authors     = ["Toyoaki Oko"]
  s.email       = ["chariderpato@gmail.com"]
  # s.homepage    = "TODO"
  s.summary     = "Capture screenshot by watir."
  s.description = "Capture screenshot by watir."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "pry"
  s.add_dependency "rails", "~> 4.1.6"
  s.add_dependency "watir"
end
