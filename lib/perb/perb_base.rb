require 'yaml'
require 'rubygems'
require "active_record"

module Perb
  class PerbBase < ActiveRecord::Base
    set_table_name :perbs
  end
end
