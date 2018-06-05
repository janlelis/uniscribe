# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + "/lib/uniscribe/version"

Gem::Specification.new do |gem|
  gem.name          = "uniscribe"
  gem.version       = Uniscribe::VERSION
  gem.summary       = "Describes Unicode characters."
  gem.description   = "Describes Unicode characters with their name and shows compositions."
  gem.authors       = ["Jan Lelis"]
  gem.email         = ["mail@janlelis.de"]
  gem.homepage      = "https://github.com/janlelis/uniscribe"
  gem.license       = "MIT"

  gem.files         = Dir["{**/}{.*,*}"].select{ |path| File.file?(path) && path !~ /^(pkg|screenshots)/}
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = "~> 2.1"
  gem.add_dependency "unicode-name", "~> 1.6"
  gem.add_dependency "unicode-sequence_name", "~> 1.2"
  gem.add_dependency "unicode-display_width", "~> 1.4"
  gem.add_dependency "unicode-emoji", "~> 1.1"
  gem.add_dependency "symbolify", "~> 1.3"
  gem.add_dependency "characteristics", ">= 0.8", "< 2.0"
  gem.add_dependency "paint", ">= 0.9", "< 3.0"
  gem.add_dependency "rationalist", "~> 2.0"
end
