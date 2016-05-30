$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auth_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auth_engine"
  s.version     = AuthEngine::VERSION
  s.authors     = ["Remy Flatt"]
  s.email       = ["remy@90seconds.tv"]
  s.homepage    = "https://github.com/remz99/auth_engine"
  s.summary     = "Gem for AuthEngine to be used with AuthProvider."
  s.description = "work in progress"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency "omniauth", "~> 1.3.1"
  s.add_dependency "omniauth-oauth2", "~> 1.3.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '~> 2.14.2'
  s.add_development_dependency 'database_cleaner', '~> 1.2.0'
end
