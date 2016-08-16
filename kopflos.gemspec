# -*- encoding: utf-8 -*-
# stub: kopflos  ruby lib

Gem::Specification.new do |s|
  s.name = "kopflos"
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Niklas Hofer"]
  s.date = "2016-08-16"
  s.description = "Starts a virtual framebuffer XServer (Xvfb) and redirects all X clients there"
  s.email = "niklas+dev@lanpartei.de"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "kopflos.gemspec",
    "lib/kopflos.rb",
    "lib/kopflos/cucumber.rb",
    "lib/kopflos/rspec.rb",
    "lib/kopflos/xvfb.rb",
    "spec/kopflos/xvfb_spec.rb",
    "spec/kopflos_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/niklas/kopflos"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "hides all your spawning X applications"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2"])
      s.add_dependency(%q<bundler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2"])
    s.add_dependency(%q<bundler>, [">= 0"])
  end
end

