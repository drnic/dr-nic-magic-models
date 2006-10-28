require 'abstract_unit'

class InvisibleModelAssocTest < Test::Unit::TestCase
  fixtures :fun_users, :groups, :group_memberships, :group_tag, :adjectives, :adjectives_fun_users
  
  def setup
    @group = groups(:first)
    @group_tag = group_tag(:first)
    @user = fun_users(:first)
    @membership = group_memberships(:first_first)
  end
  
  def test_hatbm  
    assert @user.adjectives == [adjectives(:first)]
  end
    
  def test_fk
    
    gt = GroupTag.find(1)

    # Not using FKs
    g = gt.group    
    assert g.class == Group
    assert g.id == 1
    
    # Using FKs
    g = gt.referenced_group    
    assert g.class == Group
    assert g.id == 1
    
  end
  
  def test_has_many
    assert_equal [@membership], @group.group_memberships
    assert_equal @group, @membership.group
  end

  def test_has_one
    assert_equal @group, @group_tag.referenced_group
    assert_equal @group_tag, @group.group_tag_as_referenced_group
  end
  
  def test_belongs_to
    assert_equal @user, @membership.fun_user
    assert_equal @group, @membership.group
    manual_result = GroupTag.find(:all, :conditions => ['group_tag.group_id = ?', @group.id]) #.sort{|a,b| a.id <=> b.id}
    auto_result = @group.group_tags #.sort{|a,b| a.id <=> b.id}
    assert manual_result == auto_result, "[#{manual_result.join(',')}] != [#{auto_result.join(',')}]"
      
  end
  
  def test_indirect
    assert_equal [@user], @group.fun_users
    assert_equal [@group], @user.groups 
  end
  
end
