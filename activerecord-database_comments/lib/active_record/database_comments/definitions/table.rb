# encoding: utf-8
module ActiveRecord
  module DatabaseComments
    module Definitions
  
      module Table
        
        extend ActiveSupport::Concern
        
        included do
          alias_method_chain :column, :comment
          puts "ActiveRecord::DatabaseComments::Definitions::Table module included into #{self.name}"
        end
      
        def column_with_comment(name, type, options = {})
          puts "ActiveRecord::DatabaseComments::Definitions::Table#column_with_comment(name: #{name}, type: #{type}, options: #{options.inspect})"
          ret_column = column_without_comment(name, type, options)
          ret_column[name].comment = options[:comment]
          ret_column
        end
        
      end
      
    end
  end
end
