if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.command_name "MiniTest #{Time.now}"
  SimpleCov.start "rails"
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"
require_relative "factories"
require 'authlogic/test_case'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  FIXTURES_PATH = "#{File.dirname(__FILE__)}/fixtures"

  def fixture(fixture_path)
    File.expand_path "#{FIXTURES_PATH}/#{fixture_path}"
  end

  def read_fixture(fixture_path)
    File.read(fixture(fixture_path))
  end

  def write_fixture(fixture_path, content)
    puts "ATENTION: fixture: '#{fixture_path}' been written"
    File.open(fixture(fixture_path), "w") { |f| f.write content }
  end

  def setup_admin_user
    @admin_user = FactoryBot.create(:admin_user)
    @controller.stubs(:current_admin_user).returns(@admin_user)
  end

  def difference_between_arrays(array1, array2)
    difference = array1.dup
    array2.each do |element|
      if index = difference.index(element)
        difference.delete_at(index)
      end
    end
    difference
  end

  def same_elements?(array1, array2)
    extra_items = difference_between_arrays(array1, array2)
    missing_items = difference_between_arrays(array2, array1)
    extra_items.empty? & missing_items.empty?
  end

  def assert_ids(array1, array2, message = nil)
    assert(same_elements?(array1.to_a, array2.to_a), message)
  end

  # Add more helper methods to be used by all tests here...
end
