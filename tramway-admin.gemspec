# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'tramway/admin/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'tramway-admin'
  s.version     = Tramway::Admin::VERSION
  s.authors     = ['Pavel Kalashnikov']
  s.email       = ['kalashnikovisme@gmail.com']
  s.homepage    = 'https://github.com/purple-magic/tramway-admin'
  s.summary     = 'Engine for admin'
  s.description = 'Engine for admin'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'tramway-core', '>= 1.18.6'
  s.add_dependency 'tramway-auth', '>= 2.0.1'
  s.add_dependency 'tramway-user', '>= 2.1.3.2'
  s.add_dependency 'bootstrap-kaminari-views', '0.0.5'
  s.add_dependency 'copyright_mafa', '~> 0.1.2', '>= 0.1.2'
  s.add_dependency 'font-awesome-rails', '~> 4.7', '>= 4.7.0.1'
  s.add_dependency 'kaminari', '>= 1.1.1'
  s.add_dependency 'ransack'
  s.add_dependency 'selectize-rails'
  s.add_dependency 'smart_buttons', '>= 1.0'
  s.add_dependency 'state_machine_buttons', '>= 1.0'
  s.add_dependency 'trap', '~> 4.0'
  s.add_dependency 'aasm'

  s.add_development_dependency 'pg'
end
