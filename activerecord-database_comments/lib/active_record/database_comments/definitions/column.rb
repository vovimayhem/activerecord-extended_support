# encoding: utf-8
module ActiveRecord
  module DatabaseComments
    module Definitions
      
      module Column
        
        extend ActiveSupport::Concern
    
        included do
          attr_accessor :comment
          alias_method_chain :to_sql, :comments
          puts "ActiveRecord::DatabaseComments::Definition::Column included into #{self.name}"
        end
    
        # Override de #to_sql
        def to_sql_with_comments
          puts "ActiveRecord::DatabaseComments::Definition::Column#to_sql_with_comments"
          
          column_sql = "#{base.quote_column_name(name)} #{sql_type}"
          column_options = {}
          column_options[:null] = null unless null.nil?
          column_options[:default] = default unless default.nil?
          
          # Cambio: column_options[:comment]
          column_options[:comment] = comment unless comment.nil?
          
          add_column_options!(column_sql, column_options) unless type.to_sym == :primary_key
          column_sql
        end
        
      end
      
    end
  end
end
