# encoding: utf-8
module ActiveRecord
  module DatabaseComments
    
    module Adapters
    
      module MysqlColumn
        
        extend ActiveSupport::Concern
        
        included do
          attr_reader :comment
          alias_method_chain :initialize,  :comment
        end
        
        def initialize_with_comment(name, default, sql_type = nil, null = true, collation = nil, comment = nil)
          initialize_without_comment(name, default, sql_type, null, collation)
          @comment = comment if comment.present?
        end
        
      end
    
      module MysqlAdapter
        
        extend ActiveSupport::Concern
        
        included do
          alias_method_chain :add_column_options!,  :comment
          alias_method_chain :columns,              :comment
          alias_method_chain :new_column,           :comment
          # alias_method_chain :create_table,         :mysql_options
          
          # Incluir patch a self::Column:
          "#{self.name}::Column".constantize.send :include, ActiveRecord::DatabaseComments::Adapters::MysqlColumn
        end
  
=begin
        def create_table_with_mysql_options(table_name, options = {}) #:nodoc:
          create_table_without_mysql_options(table_name, options.reverse_merge(options: options[:mysql_options] ? options[:mysql_options] : "ENGINE=InnoDB"))
        end
=end
        def new_column_with_comment(field, default, type, null, collation, comment) # :nodoc:
          "#{self.class.name}::Column".constantize.new(field, default, type, null, collation, comment)
        end
        
        def table_options(table_name)
          sql = "SHOW TABLE STATUS "
          sql << "IN #{quote_table_name(current_database)} "
          sql << "LIKE #{quote(table_name)}"
          ohmy = execute_and_free(sql, 'SCHEMA') do |result|
            each_hash(result).map do |field|
              "ENGINE=#{field[:Engine]} COLLATE=#{field[:Collation]} COMMENT='#{field[:Comment]}'"
            end
          end
          ohmy.first
        end
        
        # Returns an array of +Column+ objects for the table specified by +table_name+.
        def columns_with_comment(table_name, name = nil)#:nodoc:
          sql = "SHOW FULL FIELDS FROM #{quote_table_name(table_name)}"
          execute_and_free(sql, 'SCHEMA') do |result|
            each_hash(result).map do |field|
              new_column_with_comment(field[:Field], field[:Default], field[:Type], field[:Null] == "YES", field[:Collation], field[:Comment])
            end
          end
        end
        
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
        
        def add_column_options_with_comment!(sql, options = {})
          add_column_options_without_comment!(sql, options)
          sql << " COMMENT '#{options[:comment]}'" if options[:comment]
          sql
        end
        
      end
    
    end
    
  end
end