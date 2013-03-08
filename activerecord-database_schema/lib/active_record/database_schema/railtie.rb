# encoding: utf-8
module ActiveRecord
  module DatabaseSchema
    
    class Railtie < ::Rails::Railtie #:nodoc:
  
      initializer 'active_record.extended_support.database_schema' do |app|
        
        ActiveSupport.on_load(:active_record) do
          
          # Agregar el modulo de parches al SchemaDumper de ActiveRecord:
          require 'active_record/database_schema/dumper'
          ActiveRecord::SchemaDumper.send :include, ActiveRecord::DatabaseSchema::Dumper
          
        end
      end
    end

  end
end