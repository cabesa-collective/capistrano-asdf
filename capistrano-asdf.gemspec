# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-asdf"
  gem.version       = '1.1.1'
  gem.licenses      = ['MIT']
  gem.authors       = ["Jean-Baptiste Poix"]
  gem.email         = ["jbpoix@inosophia.com"]
  gem.description   = %q{ASDF integration for Capistrano}
  gem.summary       = %q{ASDF integration for Capistrano}
  gem.homepage      = "https://github.com/cabesa-collective/capistrano-asdf"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~> 3.0'
  gem.add_dependency 'sshkit', '~> 1.2'

end
