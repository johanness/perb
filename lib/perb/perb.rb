require 'yaml'
require 'rubygems'
require 'active_record'

module Perb
  require File.expand_path('../../../lib/perb/perb_test', __FILE__)
  config=File.expand_path('~/.perb/database.yml')
  config_yml=(YAML::load_file(config))
  connection = ActiveRecord::Base.establish_connection(config_yml)
end
