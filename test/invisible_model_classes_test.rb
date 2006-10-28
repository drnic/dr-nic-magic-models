require 'abstract_unit'

class InvisibleModelClassesTest < Test::Unit::TestCase

  def setup

  end
      
  def test_available
    assert_not_nil Group
    assert_not_nil FunUser
    assert_not_nil GroupMembership
    assert_not_nil GroupTag, "Could not find GroupTag with singularized table name 'GroupTag'"
  end

  def test_table_names
    assert_equal 'groups', Group.table_name
    assert_equal 'fun_users', FunUser.table_name
    assert_equal 'group_memberships', GroupMembership.table_name
    assert_equal 'group_tag', GroupTag.table_name
  end
  
end
