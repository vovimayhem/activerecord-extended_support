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

  def test_add_unsigned_integer_column
  	assert_equal "ALTER TABLE `people` ADD `sibling_count` int(11) UNSIGNED", add_column(:people, :sibling_count, :integer, :unsigned => true)
  end

  def test_add_unsigned_integer_column_with_other_options
    assert_equal "ALTER TABLE `people` ADD `sibling_count` int(11) UNSIGNED DEFAULT 15 NOT NULL", add_column(:people, :sibling_count, :integer, unsigned: true, null: false, default: 15)
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
