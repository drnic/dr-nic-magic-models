require 'abstract_unit'
require 'pp'

class InvisibleModelAccessTest < Test::Unit::TestCase
  # fixtures :fun_users, :groups, :group_memberships, :group_tag
  
  def setup
    create_fixtures :fun_users, :groups, :group_memberships, :group_tag
    @classes = [FunUser, Group, GroupMembership, GroupTag]
    @group = Group.find(:first)
  end
  
  def test_attributes
    assert_not_nil @group.name
  end
  
  def test_find
    @classes.each do |klass|
      assert_not_nil obj = klass.find(1)
      assert_equal klass, obj.class
    end
  end
  
  def test_sti
    require 'fun_user_plus'
    x = FunUserPlus.find(:all)
    assert x.inject {|n,v| n &= v.class == FunUserPlus}, "Wrong object class in FunUserPlus.find(:all)"
    plus = x.first
    assert_not_nil plus
    assert plus.is_a?(FunUser)
    assert plus.class == FunUserPlus
  end
  
  def test_new
    assert group = Group.new(:name => 'New Group')
    assert_equal Group, group.class
  end
  
  def test_update
    assert @group.update_attributes(:name => 'Group 1'), "Couldn't update:\n#{str=""; @group.errors.each_full { |msg| str += "#{msg}\n" }; str }"
  end
  
  def test_delete
    assert @group.destroy
  end
  
  def test_validations
    group = Group.new
    group.description = "x"*100
    group.some_int = 99.9
    group.some_float = "bah"     
    # Active record seems to interpolate booleans anyway to either true, false or nil...    
    # group.some_bool = "xxx" => false (!)
    
    assert !group.valid?, "Group should not be valid"
    [:name, :description, :some_int, :some_float].each do |x|
      assert_not_nil group.errors[x], "Failed on #{x}=[#{group.send(x)}], it should be invalid"
    end

    group = Group.new
    group.name = "name"
    group.description = "x"*49
    group.some_int = 99
    group.some_float = 99.9
    group.some_bool = true
    assert group.valid?, "Group should be valid"
    
    group.name = @group.name
    assert !group.valid?, "Groups should have unique names"
  end
end
