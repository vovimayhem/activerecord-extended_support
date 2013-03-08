# encoding: utf-8
module ActiveRecord
  module DatabaseUnsignedColumns
    module Adapters
      
      # Basado en http://thewebfellas.com/blog/2008/6/2/unsigned-integers-for-mysql-on-rails
      # Modulo con extensiones/patches para ActiveRecord::Adapters::MysqlAdapter
      module MysqlAdapter
        
        extend ActiveSupport::Concern
      
        # Se ejecuta cuando el modulo ha sido incluido en la clase
        included do
          self::NATIVE_DATABASE_TYPES[:primary_key] = 'INT UNSIGNED DEFAULT NULL auto_increment PRIMARY KEY'
          alias_method_chain :add_column_sql, :unsigned
          alias_method_chain :type_to_sql,    :unsigned
          # alias_method_chain :create_table,         :mysql_options
          
          # Incluir patch a self::Column:
          #"#{self.name}::Column".constantize.send :include, NumericTypeColumn::ActiveRecord::MysqlColumnPatch
        end
    
=begin
          def create_table_with_mysql_options(table_name, options = {}) #:nodoc:
            create_table_without_mysql_options(table_name, options.reverse_merge(options: options[:mysql_options] ? options[:mysql_options] : "ENGINE=InnoDB"))
          end
=end
          
          protected
        
        def add_column_sql_with_unsigned(table_name, column_name, type, options = {})
          is_unsigned_valid = (((options.has_key? :unsigned) && (options[:unsigned] == true)) && (['integer', 'decimal', 'float', 'boolean'].include? type.to_s))
          add_column_sql = "ADD #{quote_column_name(column_name)} #{type_to_sql(type, options[:limit], options[:precision], options[:scale], is_unsigned_valid)}"
          add_column_options!(add_column_sql, options)
          add_column_position!(add_column_sql, options)
          add_column_sql
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

