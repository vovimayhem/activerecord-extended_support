# encoding: utf-8
module ActiveRecord
  module DatabaseUnsignedColumns
    
    class Railtie < ::Rails::Railtie #:nodoc:
  
      initializer 'active_record.extended_support.database_unsigned_columns' do |app|
        
        ActiveSupport.on_load(:active_record) do
          
          # Agregar el modulo para soportar definiciones de columnas unsigned:
          require 'active_record/database_unsigned_columns/definitions/column'
          ActiveRecord::ConnectionAdapters::ColumnDefinition.send :include, ActiveRecord::DatabaseUnsignedColumns::Definitions::Column
          
          # Agregar el modulo para soportar definiciones de tablas con columnas unsigned:
          require 'active_record/database_unsigned_columns/definitions/table'
          ActiveRecord::ConnectionAdapters::TableDefinition.send  :include, ActiveRecord::DatabaseUnsignedColumns::Definitions::Table
          
          # Agregar modulo a los adapters de BD:
          require 'active_record/database_unsigned_columns/adapters/mysql_adapter'
          [
            "ActiveRecord::ConnectionAdapters::MysqlAdapter",
            "ActiveRecord::ConnectionAdapters::Mysql2Adapter",
            "ActiveRecord::ConnectionAdapters::Mysql2SpatialAdapter", # Adapter para rgeo-mysql
            "ArJdbc::MySQL"                                           # Adapter para jRuby JDBC
          ].each do |mysql_adapter_class|
            adapter_class = mysql_adapter_class.safe_constantize
            adapter_class.send :include, ActiveRecord::DatabaseUnsignedColumns::Adapters::MysqlAdapter if adapter_class.present?
          end
          
        end
        
      end
      
    end

  end
end