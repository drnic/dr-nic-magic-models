# Mixed into a class that is dynamically created, unless
# the class was created by the Schema.load_schema process
# which builds the whole class, thus no magicalness is 
# needed
module DrNicMagicModels::MagicModel
  def self.append_features(base)
    super
    base.send(:include, InstanceMethods)
    class << base
      # Returns the AssociationReflection object for the named +aggregation+ (use the symbol). Example:
      #   Account.reflect_on_association(:owner) # returns the owner AssociationReflection
      #   Invoice.reflect_on_association(:line_items).macro  # returns :has_many
      def reflect_on_association(association)
        unless reflections[association]
          # See if an assocation can be generated
          self.new.send(association) rescue nil
        end
        reflections[association].is_a?(ActiveRecord::Reflection::AssociationReflection) ? reflections[association] : nil
      end
    end
  end
  
  module InstanceMethods
    
    def method_missing(method, *args, &block)
      begin
        super 
      rescue
        if unknown_method? method
          result = find_belongs_to method, *args, &block 
          result = find_has_some method, *args, &block if not result
          result = find_has_some_indirect method, *args, &block if not result
          return result if result
        end
        add_known_unknown method
        raise
      end
    end
    
    def add_known_unknown(method)
      @known_unknowns ||= {}
      @known_unknowns[method] = true
    end
      
    def unknown_method?(method)
      @known_unknowns.nil? or @known_unknowns.include? method
    end
    
    def find_belongs_to(method, *args, &block)
      method_clean = clean_method method
      fkc = 
        begin
          self.class.connection.foreign_key_constraints(self.class.table_name, method_clean) 
        rescue NotImplementedError 
          nil
        end
      if !fkc.nil? && fkc.length > 0
        foreign_key = fkc.first.foreign_key
        options = {:dependent => :destroy, 
          :foreign_key => fkc.first.foreign_key, 
          :class_name => self.class.class_name(fkc.first.reference_table)}
      else
        foreign_key = self.class.columns.select {|column| column.name == method_clean.to_s.foreign_key}.first
      end
      options ||= {}
      return add_belongs_to(method, method_clean, options, *args, &block) if foreign_key
    end

    def add_belongs_to(method, method_clean, options, *args, &block)
      self.class.send 'belongs_to', method_clean.to_sym, options rescue puts $!
      self.send(method, *args, &block)
    end
    
    def find_has_some(method, *args, &block)
      method_clean = clean_method method
      fkc = [method_clean.to_s.pluralize, method_clean.to_s.singularize].inject({}) do |pair, table_name|
        fkc = begin
                self.class.connection.foreign_key_constraints(table_name)
              rescue NotImplementedError
                nil
              rescue  ActiveRecord::StatementInvalid
                nil
              end
        pair[table_name] = fkc if not fkc.blank?
        pair
      end
      if not fkc.blank?
        # assumes there is only one table found - that schema doesn't have a singular and plural table of same name
        foreign_key = fkc.values.first.find {|fk| fk.reference_table == self.class.table_name}
        if foreign_key
          foreign_key = foreign_key.foreign_key
          table_name = fkc.keys.first
          klass = Module.const_get table_name.singularize.camelize rescue nil
          options = {:foreign_key => foreign_key, :class_name => klass.name}
        end
      end
      unless foreign_key
        klass = Module.const_get method_clean.to_s.downcase.singularize.camelize rescue nil
        foreign_key = klass.columns.select {|column| column.name == self.class.name.foreign_key}.first if klass
      end
      options ||= {}
      return add_has_some(method, method_clean, options, *args, &block) if foreign_key
    end
          
    def add_has_some(method, method_clean, options, *args, &block)
      association = method_clean.singularize == method_clean ? 'has_one' : 'has_many'
      self.class.send association, method_clean.to_sym, options rescue puts $!
      self.send(method, *args, &block)
    end
    
    def find_has_some_indirect(method, *args, &block)
      klass = Module.const_get method.to_s.downcase.singularize.camelize rescue return
      join_table = nil
      self.connection.tables.each do |table|
        unless [self.class.table_name, klass.table_name].include? table
          columns = self.connection.columns(table).map(&:name)
          join_table = table if columns.include?(self.class.to_s.foreign_key) and columns.include?(klass.to_s.foreign_key) 
        end
        break if join_table
      end
      return add_has_some_through(join_table, method, *args, &block) if join_table
    end
    
    def add_has_some_through(join_table, method, *args, &block)
      self.class.send 'has_many', method, :through => join_table.to_sym
      self.send(method, *args, &block)
    end
    
  private
    
    def clean_method(method)
      method.to_s.gsub(/=$/,'') # remove any = from the end of the method name
    end
  end
end