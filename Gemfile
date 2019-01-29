source ENV['GEM_SOURCE'] || "https://rubygems.org"

if ENV.key?('PUPPET_VERSION')
  puppetversion = "= #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 4.7' , '< 6.0']
end
 
 gem 'json_pure'
 gem 'rake'
 gem 'ruby'
 gem 'rubocop'
 gem 'puppet-lint'
 gem 'rspec-puppet'
 gem 'puppet', puppetversion
 gem 'puppet-syntax'
