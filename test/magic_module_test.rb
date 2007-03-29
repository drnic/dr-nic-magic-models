require 'abstract_unit'

module MagicGroup
  magic_module 'group_'
end

class MagicModuleTest < Test::Unit::TestCase

  def setup

  end
      
  def test_table_prefix
    assert_nothing_thrown { MagicGroup::Membership }
    assert_equal('group_memberships', MagicGroup::Membership.table_name)
    assert_nothing_thrown { MagicGroup::Tag }
    assert_equal('group_tag', MagicGroup::Tag.table_name)
  end
  
end
