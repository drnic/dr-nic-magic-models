module DrNicMagicModels
  class Inflector
    def table_names   ; DrNicMagicModels::Schema.table_names; end
    def tables        ; DrNicMagicModels::Schema.tables; end
    def models        ; DrNicMagicModels::Schema.model; end
    
    def class_name(table_name)
      ActiveRecord::Base.class_name(table_name)
    end
    
    def post_class_creation(klass)
    end
  end
end