# encoding: utf-8
module ActiveRecord
  module DatabaseUnsignedColumns
    module Definitions
  
      # Basado en http://thewebfellas.com/blog/2008/6/2/unsigned-integers-for-mysql-on-rails
      # Modulo con extensiones/patches para ActiveRecord::ConnectionAdapters::ColumnDefinition.
      module Column
        
        extend ActiveSupport::Concern
      
        included do
          attr_accessor :unsigned
          alias_method_chain :sql_type, :unsigned
          puts "ActiveRecord::DatabaseUnsignedColumns::Definitions::Column included into #{self.name}"
        end
    
        # Override de #sql_type
        def sql_type_with_unsigned
          puts "ActiveRecord::DatabaseUnsignedColumns::Definitions::Column#sql_type_with_unsigned"
          # Cambio: signature de call base.type_to_sql:
          if base.method(:type_to_sql).parameters.include?([:opt, :unsigned])
            base.type_to_sql(type.to_sym, limit, precision, scale, unsigned) rescue type
          else
            base.type_to_sql(type.to_sym, limit, precision, scale) rescue type
          end
        end
        
      end
      
    end
  end
end
