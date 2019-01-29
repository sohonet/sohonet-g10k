require 'rake'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = [
  'spec/**/*',
  'pkg/**/*',
  'tests/**/*',
  'vagrant/**/*'
]

PuppetSyntax.exclude_paths = exclude_paths
PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.with_context = true
PuppetLint.configuration.relative = true
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_duplicate_params')

task :test => [:lint, :syntax, :spec]
task :default => [:test]
