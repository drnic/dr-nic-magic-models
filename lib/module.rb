class Module
  alias :normal_const_missing :const_missing
  
  def const_missing(class_id)
    #puts "const_missing('#{class_id}')"
    #raise 'foo' rescue puts $!.backtrace
    begin
      return normal_const_missing(class_id)
    rescue
    end
    unless table_name = DrNicMagicModels::Schema.models[class_id]
      raise NameError.new("uninitialized constant #{class_id}") if DrNicMagicModels::Schema.models.enquired? class_id
    end
    superklass = DrNicMagicModels::Schema.superklass || ActiveRecord::Base
    klass = create_class(class_id, superklass) do
      set_table_name table_name
      include DrNicMagicModels::MagicModel
      extend DrNicMagicModels::Validations
    end
    klass.generate_validations # need to call this AFTER the class name has been assigned
    DrNicMagicModels::Schema.inflector.post_class_creation klass
    klass
  end

  def create_class(class_name, superclass, &block)
    klass = Class.new superclass, &block
    Object.const_set class_name, klass
  end
end