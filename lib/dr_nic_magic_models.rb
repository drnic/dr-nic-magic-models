$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined?(ActiveRecord)
  begin
    require 'active_record'  
  rescue LoadError
    require 'rubygems'
    require_gem 'activerecord'
  end
end

module DrNicMagicModels
    Logger = RAILS_DEFAULT_LOGGER rescue Logger.new(STDERR)
end

require 'dr_nic_magic_models/magic_model'
require 'dr_nic_magic_models/schema'
require 'dr_nic_magic_models/validations'
require 'dr_nic_magic_models/inflector'
require 'base'
require 'module'
require 'rails' rescue nil
require 'connection_adapters/abstract_adapter'
require 'connection_adapters/mysql_adapter'
require 'connection_adapters/postgresql_adapter'

# load the schema
# TODO - add this to README - DrNicMagicModels::Schema.load_schema(true)

class ActiveRecord::Base
  include DrNicMagicModels::MagicModel
  extend DrNicMagicModels::Validations
end