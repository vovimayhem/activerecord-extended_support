# encoding: utf-8
if defined?(Rails::Railtie)
  require 'active_record/database_comments/railtie'
  require 'active_record/database_schema/railtie'
  require 'active_record/database_unsigned_columns/railtie'
end
