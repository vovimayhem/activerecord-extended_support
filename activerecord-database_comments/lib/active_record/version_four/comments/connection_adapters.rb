# encoding: utf-8
module ActiveRecord
  module VersionFour
    module Comments
    
      module ConnectionAdapters
    
        # Basado en http://thewebfellas.com/blog/2008/6/2/unsigned-integers-for-mysql-on-rails
        # Modulo con extensiones/patches para ActiveRecord::ConnectionAdapters::ColumnDefinition.
        module ColumnDefinition
          
          extend ActiveSupport::Concern
        
          included do
            attr_accessor :comment
          end
          
        end

        module TableDefinition
          extend ActiveSupport::Concern
        
          included do
            alias_method_chain :new_column_definition, :comment
          end

          def new_column_definition_with_comment(name, type, options) # :nodoc:
            column = new_column_definition_without_comment(name, type, options)
            column.comment = options[:comment] if options.has_key? :comment
            column
          end

        end

        module MysqlAdapter
          extend ActiveSupport::Concern
        
          included do
            alias_method_chain :add_column_options!,  :comment
            alias_method_chain :column_spec,          :comment
            alias_method_chain :migration_keys,       :comment
            alias_method_chain :columns, :comment
            alias_method_chain :new_column, :comment
          end

          def add_column_options_with_comment!(sql, options) #:nodoc:
            add_column_options_without_comment!(sql, options)
            sql << " COMMENT '#{options[:column].comment}'" if options[:column].respond_to? :comment and options[:column].comment.present?
          end

          def column_spec_with_comment(column, types)
            
            # By default, it's ActiveRecord::ConnectionAdapters::ColumnDumper#column_spec
            spec = column_spec_without_comment(column, types)
            
            spec[:comment] = "comment: '#{column.comment}'" if column.respond_to? :comment and column.comment.present?
            
            spec

          end

          def migration_keys_with_comment
            migration_keys_without_comment + [:comment]
          end

          # Returns an array of +Column+ objects for the table specified by +table_name+.
          def columns_with_comment(table_name)#:nodoc:
            sql = "SHOW FULL FIELDS FROM #{quote_table_name(table_name)}"
            execute_and_free(sql, 'SCHEMA') do |result|
              each_hash(result).map do |field|
                field_name = set_field_encoding(field[:Field])
                new_column(field_name, field[:Default], field[:Type], field[:Null] == "YES", field[:Collation], field[:Extra], field[:Comment])
              end
            end
          end

          def new_column_with_comment(field, default, type, null, collation, extra = "", comment = nil) # :nodoc:
            ::ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column.new(field, default, type, null, collation, strict_mode?, extra, comment)
          end

          module Column
            extend ActiveSupport::Concern

            included do
              attr_reader :comment
              alias_method_chain :initialize, :comment
            end

            def initialize_with_comment(name, default, sql_type = nil, null = true, collation = nil, strict = false, extra = "", comment = nil)
              initialize_without_comment(name, default, sql_type, null, collation, strict, extra)
              @comment = comment
            end

          end

        end
        
      end

    end
  end
end
