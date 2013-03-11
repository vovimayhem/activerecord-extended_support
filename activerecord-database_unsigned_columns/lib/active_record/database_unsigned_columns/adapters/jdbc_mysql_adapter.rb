# endocing: utf-8
module ActiveRecord
  module DatabaseUnsignedColumns
    module Adapters
      
      module JdbcMysqlAdapter
        
        extend ActiveSupport::Concern
        
        included do
          puts "Module 'ActiveRecord:DatabaseUnsignedColumns::Adapters::JdbcMysqlAdapter included to '#{self.name}'"
          alias_method_chain :modify_types, :unsigned
          alias_method_chain :type_to_sql,  :unsigned
          # alias_method_chain :create_table,         :mysql_options
        end
        
        def modify_types_with_unsigned(types)
          types = modify_types_without_unsigned(types)
          types[:primary_key] = "INT UNSIGNED DEFAULT NULL auto_increment PRIMARY KEY" if types.has_key? :primary_key
          types
        end
          
        def type_to_sql_with_unsigned(type, limit = nil, precision = nil, scale = nil, unsigned = false)
          sql = type_to_sql_without_unsigned(type, limit, precision, scale)
          sql << ' UNSIGNED' if unsigned && (['integer', 'decimal', 'float', 'boolean'].include? type.to_s)
          sql
        end
        
      end
      
    end
  end
end