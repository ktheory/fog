require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

Shindo.tests('test_helper') do
  tests('#validate_data_format') do

    tests('returns true') do

      test('when format of value matches') do
        validate_data_format({:a => :b}, {:a => Symbol})
      end

      test('when format of nested array elements matches') do
        validate_data_format({:a => [:b, :c]}, {:a => [Symbol]})
      end

      test('when format of nested hash matches') do
        validate_data_format({:a => {:b => :c}}, {:a => {:b => Symbol}})
      end

    end

    tests('returns false') do

      test('when format of value does not match') do
        !validate_data_format({:a => :b}, {:a => String})
      end

      test('when not all keys are checked') do
        !validate_data_format({:a => :b}, {})
      end

      test('when some keys do not appear') do
        !validate_data_format({}, {:a => String})
      end

    end

  end
end
