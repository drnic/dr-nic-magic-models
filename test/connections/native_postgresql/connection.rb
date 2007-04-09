print "Using Postgres\n"
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

db1 = "dr_nic_magic_models_unittest"

ActiveRecord::Base.establish_connection(
  :adapter  => "postgresql",
  :encoding => "utf8",
  :database => db1
)
