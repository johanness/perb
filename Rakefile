require 'active_record'
require 'logger'
require 'yaml'
require 'ruby-debug'

namespace :db do
  db_yml=File.expand_path('../config/database.yml', __FILE__)
  config=YAML::load(File.open(db_yml))
  ActiveRecord::Base.establish_connection(config)

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  desc "Drop the database"
  task :drop => :environment do
    if config['adapter'] == "sqlite3"
      db_file=config['database']
      `rm "#{db_file}"`
    else
      puts "Support for dropping databases other than SQLite not yet implemented"
    end
  end

  task :environment do
    ActiveRecord::Base.logger = Logger.new(File.open('log/database.log', 'a'))
  end
end
