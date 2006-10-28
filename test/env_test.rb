require 'abstract_unit'

class EnvTest < Test::Unit::TestCase

  def test_modules
    assert_not_nil DrNicMagicModels
    assert_not_nil DrNicMagicModels::Validations
    assert_not_nil DrNicMagicModels::Schema
  end
end