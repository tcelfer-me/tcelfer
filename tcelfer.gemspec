# frozen_string_literal: true

# Copyright (C) 2019  Anthony Gargiulo <anthony@agargiulo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcelfer/version'

github_baseurl = 'github.com/agargiulo/tcelfer'

Gem::Specification.new do |spec|
  spec.name          = 'tcelfer'
  spec.version       = Tcelfer::VERSION
  spec.authors       = ['Anthony Gargiulo']
  spec.email         = ['anthony@agargiulo.com']
  spec.licenses      = ['GPL-3.0-only']

  spec.summary       = 'Reflect on your day and keep track'
  spec.description   = 'Reflect on your day, prompts with thor or webapp and stores to db'
  spec.homepage      = "https://#{github_baseurl}"

  spec.metadata = {
    # 'allowed_push_host' => 'https://rubygems.org', # TODO: See if there's a way to specify more than one of these?
    'homepage_uri'    => spec.homepage,
    'source_code_uri' => spec.homepage,
    'github_url'      => "ssh://#{github_baseurl}"
  }

  # Specify which files should be added to the gem when it is released.
  # No git please | Sane defaults suggested by the rubygem docs.
  spec.files = Dir.glob(
    %w[lib/**/*.rb [A-Z]* spec/**/* db/migrations/**/[0-9]*.rb config/*example*.yml]
  )

  spec.bindir        = 'exe'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables   = Dir['exe/*'].map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',             '~> 2.0'
  spec.add_development_dependency 'dotenv',              '~> 2.7'
  spec.add_development_dependency 'pry',                 '~> 0.12'
  spec.add_development_dependency 'rake',                '~> 12.3'
  spec.add_development_dependency 'rspec',               '~> 3.8'
  spec.add_development_dependency 'rubocop',             '~> 0.74'
  spec.add_development_dependency 'rubocop-performance', '~> 1.4'

  spec.add_runtime_dependency 'anyway_config',   '~> 1.4'
  spec.add_runtime_dependency 'paint',           '~> 2.1'
  spec.add_runtime_dependency 'sequel',          '~> 5.23'
  spec.add_runtime_dependency 'sqlite3',         '~> 1.4'
  spec.add_runtime_dependency 'terminal-table',  '~> 1.8'
  spec.add_runtime_dependency 'thor',            '~> 0.20'
  spec.add_runtime_dependency 'tty-prompt',      '~> 0.19'
end
