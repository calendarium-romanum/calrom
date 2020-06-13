# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calrom/version'

Gem::Specification.new do |spec|
  spec.name          = 'calrom'
  spec.version       = Calrom::VERSION
  spec.authors       = ['Jakub Pavlík']
  spec.email         = ['jkb.pavlik@gmail.com']

  spec.summary       = 'Command line utility providing access to the Roman Catholic liturgical calendar (post-Vatican II)'
  spec.homepage      = 'https://github.com/calendarium-romanum/calrom'
  spec.licenses      = ['GPL-3.0']

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'calendarium-romanum', '~> 0.6.0'
  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'pattern-match', '~> 1.0'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'cucumber', '~> 1.3'
  spec.add_development_dependency 'aruba', '~> 0.14'
end
