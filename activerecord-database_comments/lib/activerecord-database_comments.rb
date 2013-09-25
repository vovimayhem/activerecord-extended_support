# encoding: utf-8

#require 'activerecord-database_schema'
#require 'active_record/database_comments/railtie' if defined?(Rails::Railtie)

require 'active_support'

if defined?(::Rails::Railtie)

  module ActiveRecord
    module Comments

      class Railtie < ::Rails::Railtie #:nodoc:

        initializer 'active_record.comments' do |app|
          load 'active_record/version_four/comments/loader.rb'
        end

      end
      
    end
  end

else
  load 'active_record/version_four/comments/loader.rb'
  # ActiveSupport.on_load :active_record do
  #   require 'activerecord-mysql-unsigned/base'
  # end
end

