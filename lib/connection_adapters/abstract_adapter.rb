
module ActiveRecord
  module ConnectionAdapters # :nodoc:

    # Generic holder for foreign key constraint meta-data from the database schema.
    class ForeignKeyConstraint < Struct.new(:name, :table, :foreign_key, :reference_table, :reference_column, :on_update, :on_delete)
    end
    
    class AbstractAdapter

      # Does this adapter support the ability to fetch foreign key information?  
      # Backend specific, as the abstract adapter always returns +false+.
      def supports_fetch_foreign_keys?
        false
      end
      
      def foreign_key_constraints(table, name = nil)
        raise NotImplementedError, "foreign_key_constraints is not implemented for #{self.class}"
      end
      
      def remove_foreign_key_constraint(table_name, constraint_name)
        raise NotImplementedError, "rename_table is not implemented for #{self.class}"
      end      

      protected
        def symbolize_foreign_key_constraint_action(constraint_action)
          return nil if constraint_action.nil?
          constraint_action.downcase.gsub(/\s/, '_').to_sym
        end
    end
  end
end
