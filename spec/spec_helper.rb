require 'webmock/rspec'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)
require 'pronto/cli'
$LOAD_PATH.push(File.dirname(__dir__))
require 'src/github_action_check_run_formatter'
