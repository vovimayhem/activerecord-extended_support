# encoding: utf-8
module ActiveRecord
  module VersionFour
    module UnsignedColumns

      module ConnectionAdapters
    
        # Basado en http://thewebfellas.com/blog/2008/6/2/unsigned-integers-for-mysql-on-rails
        # Modulo con extensiones/patches para ActiveRecord::ConnectionAdapters::ColumnDefinition.
        module ColumnDefinition
          
          extend ActiveSupport::Concern
        
          included do
            attr_accessor :unsigned
          end
          
        end

        module TableDefinition
          extend ActiveSupport::Concern
        
          included do
            alias_method_chain :new_column_definition, :unsigned
          end

          def new_column_definition_with_unsigned(name, type, options) # :nodoc:
            column = new_column_definition_without_unsigned(name, type, options)

            column.unsigned = options[:unsigned] if options.has_key? :unsigned
            column
          end

        end

        module AbstractMysqlAdapter
          extend ActiveSupport::Concern
        
          included do
            alias_method_chain :add_column_options!,  :unsigned
            alias_method_chain :column_spec,          :unsigned
            alias_method_chain :migration_keys,       :unsigned
          end

          def add_column_options_with_unsigned!(sql, options) #:nodoc:
            sql << " UNSIGNED" if options[:column].respond_to? :unsigned and options[:column].unsigned
            add_column_options_without_unsigned!(sql, options)
          end

          def column_spec_with_unsigned(column, types)
            
            # By default, it's ActiveRecord::ConnectionAdapters::ColumnDumper#column_spec
            spec = column_spec_without_unsigned(column, types)
            
            spec[:unsigned] = "unsigned: true" if column.sql_type =~ /unsigned/i
            
            spec

          end

          def migration_keys_with_unsigned
            migration_keys_without_unsigned + [:unsigned]
          end

        end
        
      end
    
    end
  end
end
