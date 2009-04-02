# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{index_lifter}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Schuerig"]
  s.date = %q{2009-04-02}
  s.description = %q{ActiveRecord utility class that disables database indexes during a block.}
  s.email = ["michael@schuerig.de"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/index_lifter.rb", "test/test_helper.rb", "test/test_index_lifter.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mschuerig/index_lifter}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{index_lifter}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{ActiveRecord utility class that disables database indexes during a block.}
  s.test_files = ["test/test_helper.rb", "test/test_index_lifter.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.0.2"])
      s.add_dependency(%q<newgem>, [">= 1.3.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.0.2"])
    s.add_dependency(%q<newgem>, [">= 1.3.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
