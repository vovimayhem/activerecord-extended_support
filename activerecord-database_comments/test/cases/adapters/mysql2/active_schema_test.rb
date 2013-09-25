require "cases/helper"

class ActiveSchemaTest < ActiveRecord::TestCase
  def setup
    @connection = ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection(@connection)

    ActiveRecord::Base.connection.singleton_class.class_eval do
      alias_method :execute_without_stub, :execute
      def execute(sql, name = nil) return sql end
    end
  end

  def teardown
    ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection(@connection)
  end

  def test_add_column_with_comment
  	assert_equal "ALTER TABLE `test_table` ADD `test_column` varchar(255) COMMENT 'test comment'", add_column(:test_table, :test_column, :string, :comment => 'test comment')
  end

  private
    def with_real_execute
      ActiveRecord::Base.connection.singleton_class.class_eval do
        alias_method :execute_with_stub, :execute
        remove_method :execute
        alias_method :execute, :execute_without_stub
      end

      yield
    ensure
      ActiveRecord::Base.connection.singleton_class.class_eval do
        remove_method :execute
        alias_method :execute, :execute_with_stub
      end
    end

    def method_missing(method_symbol, *arguments)
      ActiveRecord::Base.connection.send(method_symbol, *arguments)
    end

    def column_present?(table_name, column_name, type)
      results = ActiveRecord::Base.connection.select_all("SHOW FIELDS FROM #{table_name} LIKE '#{column_name}'")
      results.first && results.first['Type'] == type
    end
end
