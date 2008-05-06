class Module
  alias :normal_const_missing :const_missing

  def const_missing(class_id)
    begin
      return normal_const_missing(class_id)
    rescue
    end
    @magic_schema ||= DrNicMagicModels::Schema.new self
    unless table_name = @magic_schema.models[class_id]
      raise NameError.new("uninitialized constant #{class_id}") if @magic_schema.models.enquired? class_id
    end
    superklass = @magic_schema.superklass || ActiveRecord::Base
    klass = create_class(class_id, superklass) do
      set_table_name table_name
      # include DrNicMagicModels::MagicModel
      # extend DrNicMagicModels::Validations
    end
    klass.generate_validations # need to call this AFTER the class name has been assigned
    @magic_schema.inflector.post_class_creation klass
    klass
  end

  def magic_module(options)
    self.instance_variable_set "@table_name_prefix", options[:table_name_prefix] if options[:table_name_prefix]
  end

  private
  def create_class(class_name, superclass, &block)
    klass = Class.new superclass, &block
    self.const_set class_name, klass
  end
end