ActiveSupport.on_load(:active_record) do
  
  require 'active_record/version_four/connection_adapters'

  # Agregar el modulo para soportar definiciones de columnas unsigned:
  ActiveRecord::ConnectionAdapters::ColumnDefinition.send :include, ActiveRecord::VersionFour::ConnectionAdapters::ColumnDefinition
  
  # Agregar el modulo para soportar definiciones de tablas con columnas unsigned:
  ActiveRecord::ConnectionAdapters::TableDefinition.send  :include, ActiveRecord::VersionFour::ConnectionAdapters::TableDefinition

  #######
  require 'active_record/connection_adapters/abstract_mysql_adapter'
  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.send  :include, ActiveRecord::VersionFour::ConnectionAdapters::AbstractMysqlAdapter
  
  # # Agregar modulo a los adapters de BD:
  # [
  #   "ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter",
  #   #"ActiveRecord::ConnectionAdapters::Mysql2Adapter",
  #   #"ActiveRecord::ConnectionAdapters::Mysql2SpatialAdapter", # Adapter para rgeo-mysql
  #   #"ArJdbc::MySQL"                                           # Adapter para jRuby JDBC
  # ].each do |mysql_adapter_class|
  #   adapter_class = mysql_adapter_class.safe_constantize
  #   if adapter_class.present?
  #     require 'active_record/database_unsigned_columns/adapters/mysql_adapter'
  #     adapter_class.send :include, ActiveRecord::DatabaseUnsignedColumns::Adapters::MysqlAdapter 
  #   end
  # end
  
  # # Agregar modulo a los adapters de JDBC:
  # [
  #   "ArJdbc::MySQL"
  # ].each do |mysql_adapter_class|
  #   adapter_class = mysql_adapter_class.safe_constantize
  #   if adapter_class.present?
  #     require 'active_record/database_unsigned_columns/adapters/jdbc_mysql_adapter'
  #     adapter_class.send :include, ActiveRecord::DatabaseUnsignedColumns::Adapters::JdbcMysqlAdapter
  #   end 
  # end
  
end