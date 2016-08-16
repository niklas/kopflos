# encoding: utf-8

require 'bundler'
# $: << File.expand_path('../lib', __FILE__)
# require 'kopflos/version'

Gem::Specification.new do |s|
  s.name         = "kopflos"
  s.version      = '0.0.2'
  s.authors      = ["Niklas Hofer"]
  s.email        = "niklas+dev@lanpartei.de"
  s.homepage     = "http://github.com/niklas/kopflos"
  s.summary      = "Run X applications hidden."
  s.description  = "Allows to run any X application on machines with no display hardware. You may find it useful to run your selenium stories on a CI server"

  s.files        = Dir['{lib,spec}/**/*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  
  s.add_dependency 'open4'
  s.add_development_dependency "rspec", "~> 2.8.0"
  s.add_development_dependency "yard", "~> 0.6.0"
  s.add_development_dependency "bundler", "~> 1.0.0"
  s.add_development_dependency "jeweler", "~> 1.5.2"
  s.add_development_dependency "rcov", ">= 0"
end
