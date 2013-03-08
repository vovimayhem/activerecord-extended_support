# encoding: utf-8
module ActiveRecord
  module DatabaseUnsignedColumns
    module Definitions
      
      # Basado en http://thewebfellas.com/blog/2008/6/2/unsigned-integers-for-mysql-on-rails
      # Modulo con extensiones/patches para ActiveRecord::ConnectionAdapters::TableDefinition
      module Table
        
        extend ActiveSupport::Concern
        
        # Ocurre al momento de incluirse éste módulo a la clase ActiveRecord::TableDefinition
        included do
          # Agregar en cadena el metodo column_with_unsigned:
          alias_method_chain :column, :unsigned
          puts "ActiveRecord::DatabaseUnsignedColumns::Definitions::Table included into #{self.name}"
        end
        
        # Permite dentro de una migracion:
        # def change
        #   create_table :tablename do |t|
        #     t.integer :uno, unsigned: true
        #   end
        # end
        def column_with_unsigned(name, type, options = {})
          puts "ActiveRecord::DatabaseUnsignedColumns::Definitions::Table#column_with_unsigned(#{name}, #{type}, #{options.inspect})"
          ret_column = column_without_unsigned(name, type, options)
          ret_column[name].unsigned = options[:unsigned]
          ret_column
        end
        
      end
  
    end
  end
end