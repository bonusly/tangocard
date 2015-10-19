$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'tangocard/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'tangocard'
  s.version     = Tangocard::VERSION
  s.authors     = ['Raphael Crawford-Marks']
  s.email       = ['raphael@bonus.ly']
  s.homepage    = 'http://bonus.ly'
  s.summary     = 'Ruby Wrapper for Tango Card RaaS API.'
  s.description = 'Tango Card provides a RaaS API for developers (https://github.com/tangocarddev/RaaS). This gem
                   provides commonsense Ruby objects to wrap the JSON endpoints of the RaaS API.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'httparty', '~> 0.11'
  s.add_dependency 'money', '~> 6.1'
  s.add_dependency 'i18n', '~> 0.6.11'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'rr', '~> 0'
end
