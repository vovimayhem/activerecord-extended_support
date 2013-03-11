# encoding: utf-8
module ActiveRecord
  module DatabaseComments
    
    class Railtie < ::Rails::Railtie #:nodoc:
    
      initializer 'active_record.extended_support.database_comments' do |app|
        
        ActiveSupport.on_load(:active_record) do
        
          # Patches para permitir definir columnas con COMMENTS en MySQL:
          # Agregar el módulo para soportar definiciones de columnas unsigned: 
          require 'active_record/database_comments/definitions/column'
          ActiveRecord::ConnectionAdapters::ColumnDefinition.send :include, ActiveRecord::DatabaseComments::Definitions::Column
          
          # Agregar el módulo para soportar definiciones de tablas con comentarios en columnas y tabla:
          require 'active_record/database_comments/definitions/table'
          ActiveRecord::ConnectionAdapters::TableDefinition.send  :include, ActiveRecord::DatabaseComments::Definitions::Table
          
          # Agregar el módulo a los adapters de BD:
          jdbc_adapter = "ArJdbc::MySQL".safe_constantize
          unless jdbc_adapter.present?
            [
              "ActiveRecord::ConnectionAdapters::MysqlAdapter",
              "ActiveRecord::ConnectionAdapters::Mysql2Adapter",
            ].each do |mysql_adapter_class|
              adapter_class = mysql_adapter_class.safe_constantize
              if adapter_class.present?
                require 'active_record/database_comments/adapters/mysql_adapter'
                adapter_class.send :include, ActiveRecord::DatabaseComments::Adapters::MysqlAdapter 
              end
            end
          end 
          
          
        end
      end
      
    end
    
  end
end