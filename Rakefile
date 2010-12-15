require 'active_record'
require 'logger'
require 'yaml'
require 'ruby-debug'
require 'rake/gempackagetask'

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

spec = Gem::Specification.new do |s|
  s.name = "perb"
  s.summary = "run httperf and save results to a database"
  s.description= "A front-end for httperf, saving test results in a database"
  s.requirements = [ 'httperf, a database frontend, couple of other things' ]
  s.version = "0.0.1"
  s.author = "Chris Flöß and Johannes Strampe"
  s.email = "cfloess@adva-business.com"
  s.platform = Gem::Platform::RUBY
  s.files = Dir['**/**']
  s.executables = [ 'perb' ]
  s.test_files = Dir["test/test*.rb"]
  s.has_rdoc = false
end

Rake::GemPackageTask.new(spec).define

