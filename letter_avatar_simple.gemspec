lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'letter_avatar_simple/version'

Gem::Specification.new do |spec|
  spec.name          = 'letter_avatar_simple'
  spec.version       = LetterAvatarSimple::VERSION
  spec.authors       = ['Discourse Developers', 'Krzysiek Szczuka', 'Mateusz Mróz', 'Jason Lee', 'Abe Voelker']
  spec.email         = ['abe@abevoelker.com']
  spec.summary       = 'Generate letter image avatars based on user initials'
  spec.homepage      = 'https://github.com/abevoelker/letter_avatar_simple'
  spec.license       = 'GPL-2.0'
  spec.files         = Dir.glob('lib/**/*') + %w(README.md CHANGELOG.md Roboto-Medium)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'mini_magick', '~> 4.0'
end
