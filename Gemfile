source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'beaker',                  :require => false
  gem 'beaker-rspec',            :require => false
  gem 'metadata-json-lint',      :require => false
  gem 'pry',                     :require => false
  gem 'puppet-lint',             :require => false
  gem 'puppet-syntax',           :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'rake',                    :require => false
  gem 'rspec-puppet',            :require => false
  gem 'serverspec',              :require => false
  gem 'simplecov',               :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
