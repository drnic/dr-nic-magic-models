require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'hoe'
require File.join(File.dirname(__FILE__), 'lib', 'dr_nic_magic_models', 'version')

AUTHOR = "nicwilliams"  # can also be an array of Authors
EMAIL = "drnicwilliams@gmail.com"
DESCRIPTION = "Dr Nic's Magic Models - Invisible validations, assocations and Active Record models themselves!"
GEM_NAME = "dr_nic_magic_models" # what ppl will type to install your gem
RUBYFORGE_PROJECT = "magicmodels" # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"


NAME = "magic_multi_connections"
REV = nil # UNCOMMENT IF REQUIRED: File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
VERS = ENV['VERSION'] || (DrNicMagicModels::VERSION::STRING + (REV ? ".#{REV}" : ""))
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', "dr_nic_magic_models documentation",
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README",
    "--inline-source"]

class Hoe
  def extra_deps 
    @extra_deps.reject { |x| Array(x).first == 'hoe' } 
  end 
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.author = AUTHOR 
  p.description = DESCRIPTION
  p.email = EMAIL
  p.summary = DESCRIPTION
  p.url = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs = ["test/**/test_*.rb"]
  p.clean_globs = CLEAN  #An array of file patterns to delete on clean.
  
  # == Optional
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  
  #p.extra_deps     - An array of rubygem dependencies.
  #p.spec_extras    - A hash of extra values to set in the gemspec.
end

# Run the unit tests

for adapter in %w( sqlite mysql postgresql ) # UNTESTED - postgresql sqlite sqlite3 firebird sqlserver sqlserver_odbc db2 oracle sybase openbase )
  Rake::TestTask.new("test_#{adapter}") { |t|
    t.libs << "test" << "test/connections/native_#{adapter}"
    t.pattern = "test/*_test{,_#{adapter}}.rb"
    t.verbose = true
  }
end

SCHEMA_PATH = File.join(File.dirname(__FILE__), *%w(test fixtures db_definitions))

desc 'Build the MySQL test databases'
task :build_mysql_databases do 
  puts File.join(SCHEMA_PATH, 'mysql.sql')
  %x( mysqladmin -u root create "#{GEM_NAME}_unittest" )
  cmd = "mysql -u root #{GEM_NAME}_unittest < \"#{File.join(SCHEMA_PATH, 'mysql.sql')}\""
  puts "#{cmd}\n"
  %x( #{cmd} )
end

desc 'Drop the MySQL test databases'
task :drop_mysql_databases do 
  %x( mysqladmin -u root -f drop "#{GEM_NAME}_unittest" )
end

desc 'Rebuild the MySQL test databases'
task :rebuild_mysql_databases => [:drop_mysql_databases, :build_mysql_databases]

desc 'Build the sqlite test databases'
task :build_sqlite_databases do 
  # puts File.join(SCHEMA_PATH, 'sqlite.sql')
  # %x( sqlite3 test.db < test/fixtures/db_definitions/sqlite.sql )
  file = File.join(SCHEMA_PATH, 'sqlite.sql')
  cmd = "sqlite3 test.db < #{file}"
  puts cmd
  %x( #{cmd} )
end

desc 'Drop the sqlite test databases'
task :drop_sqlite_databases do 
  %x( rm -f test.db )
end

desc 'Rebuild the sqlite test databases'
task :rebuild_sqlite_databases => [:drop_sqlite_databases, :build_sqlite_databases]

desc 'Build the PostgreSQL test databases'
task :build_postgresql_databases do 
  %x( createdb "#{GEM_NAME}_unittest" )
  %x( psql "#{GEM_NAME}_unittest" -f "#{File.join(SCHEMA_PATH, 'postgresql.sql')}" )
end

desc 'Drop the PostgreSQL test databases'
task :drop_postgresql_databases do 
  %x( dropdb "#{GEM_NAME}_unittest" )
end

desc 'Rebuild the PostgreSQL test databases'
task :rebuild_postgresql_databases => [:drop_postgresql_databases, :build_postgresql_databases]


desc 'Generate website files'
task :website_generate do
  sh %{ ruby scripts/txt2html website/index.txt > website/index.html }
  sh %{ ruby scripts/txt2js website/version.txt > website/version.js }
  sh %{ ruby scripts/txt2js website/version-raw.txt > website/version-raw.js }
end

desc 'Upload website files to rubyforge'
task :website_upload do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
  local_dir = 'website'
  sh %{rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload]
