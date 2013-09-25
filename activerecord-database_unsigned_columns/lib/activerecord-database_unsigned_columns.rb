# encoding: utf-8

#require 'activerecord-database_schema'
#require 'active_record/database_unsigned_columns/railtie' if defined?(Rails::Railtie)

require 'active_support'

if defined?(::Rails::Railtie)

  module ActiveRecord
    module DatabaseUnsignedColumns

      class Railtie < ::Rails::Railtie #:nodoc:

        initializer 'active_record.extended_support.database_unsigned_columns' do |app|
          load 'active_record/version_four/loader.rb'
        end

      end
      
    end
  end

else
	load 'active_record/version_four/loader.rb'
  # ActiveSupport.on_load :active_record do
  #   require 'activerecord-mysql-unsigned/base'
  # end
end