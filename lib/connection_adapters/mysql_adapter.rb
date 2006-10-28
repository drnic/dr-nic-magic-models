# Foreign Key support from http://wiki.rubyonrails.org/rails/pages/Foreign+Key+Schema+Dumper+Plugin

module ActiveRecord
  module ConnectionAdapters
    class MysqlAdapter < AbstractAdapter
      def supports_fetch_foreign_keys?
        true
      end
      
      def foreign_key_constraints(table, name = nil)
        constraints = [] 
        execute("SHOW CREATE TABLE #{table}", name).each do |row|
          row[1].each do |create_line|
            if create_line.strip =~ /CONSTRAINT `([^`]+)` FOREIGN KEY \(`([^`]+)`\) REFERENCES `([^`]+)` \(`([^`]+)`\)([^,]*)/          
              constraint = ForeignKeyConstraint.new(Regexp.last_match(1), table, Regexp.last_match(2), Regexp.last_match(3), Regexp.last_match(4), nil, nil)
            
              constraint_params = {}
              
              unless Regexp.last_match(5).nil?
                Regexp.last_match(5).strip.split('ON ').each do |param|
                  constraint_params[Regexp.last_match(1).upcase] = Regexp.last_match(2).strip.upcase if param.strip =~ /([^ ]+) (.+)/
                end
              end
            
              constraint.on_update = symbolize_foreign_key_constraint_action(constraint_params['UPDATE']) if constraint_params.include? 'UPDATE'
              constraint.on_delete = symbolize_foreign_key_constraint_action(constraint_params['DELETE']) if constraint_params.include? 'DELETE'

              constraints << constraint
            end
          end
        end
    
        constraints
      end
      
      def remove_foreign_key_constraint(table_name, constraint_name)
        execute "ALTER TABLE #{table_name} DROP FOREIGN KEY #{constraint_name}"
      end      

    end
  end
end
