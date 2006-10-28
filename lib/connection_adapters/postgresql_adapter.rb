# Foreign Key support from http://wiki.rubyonrails.org/rails/pages/Foreign+Key+Schema+Dumper+Plugin

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter

      def supports_fetch_foreign_keys?
        true
      end

      def foreign_key_constraints(table, name = nil)
        
        
        sql =  "SELECT conname, pg_catalog.pg_get_constraintdef(oid) AS consrc FROM pg_catalog.pg_constraint WHERE contype='f' "
        sql += "AND conrelid = (SELECT oid FROM pg_catalog.pg_class WHERE relname='#{table}')"
        
        result = query(sql, name)
        
        keys = []
        re = /(?i)^FOREIGN KEY \((.+)\) REFERENCES (.+)\((.+)\)(?: ON UPDATE (\w+))?(?: ON DELETE (\w+))?$/
        result.each do |row| 
          # pg_catalog.pg_get_constraintdef returns a string like this:
          # FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE          
          if match = re.match(row[1])
            
            keys << ForeignKeyConstraint.new(row[0],
                                             table,
                                             match[1],
                                             match[2],
                                             match[3],
                                             symbolize_foreign_key_constraint_action(match[4]),
                                             symbolize_foreign_key_constraint_action(match[5]))
          end
        end
        
        keys
      end
      
      def remove_foreign_key_constraint(table_name, constraint_name)
        execute "ALTER TABLE #{table_name} DROP CONSTRAINT #{constraint_name}"
      end
      
    end
  end
end
