# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ppgit}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alain Ravet"]
  s.date = %q{2010-07-21}
  s.description = %q{git users' pairs switcher}
  s.email = %q{alain.ravet+git@gmail.com}
  s.executables = ["git-pp", "ppgit"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/git-pp",
     "bin/ppgit",
     "lib/ppgit.rb",
     "lib/ppgit/usage.txt",
     "lib/ppgit/utils.rb",
     "ppgit.gemspec",
     "spec/ppgit_clear_spec.rb",
     "spec/ppgit_email_root_spec.rb",
     "spec/ppgit_spec.rb",
     "spec/ppgit_usage_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/alainravet/ppgit}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{git users' pairs switcher}
  s.test_files = [
    "spec/ppgit_clear_spec.rb",
     "spec/ppgit_email_root_spec.rb",
     "spec/ppgit_spec.rb",
     "spec/ppgit_usage_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

