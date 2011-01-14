lib_path=File.expand_path("../", __FILE__)
if File.exists?(lib_path)
  $LOAD_PATH<<lib_path unless $LOAD_PATH.include?(lib_path)
end

module Perb
  require 'perb/perb_test'
  require 'perb/perb_parser'
  require 'perb/perb_base'
  require 'perb/session'
  require 'ruby-debug'

  config=File.expand_path('~/.perb/database.yml')
  config_yml=(YAML::load_file(config))

  connection = PerbBase.establish_connection(config_yml)
end
