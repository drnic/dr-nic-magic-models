require 'abstract_unit'
require 'pp'

module TestBed
  class Group < ActiveRecord::Base
    generate_validations
  end
end

class TestExistingModel < Test::Unit::TestCase
  # fixtures :fun_users, :groups, :group_memberships, :group_tag
  
  def setup
    create_fixtures :fun_users, :groups, :group_memberships, :group_tag
  end
  
  def test_valid
    assert(!TestBed::Group.new.valid?)
  end
end