require "test_helper"

class TaskerTest < ActiveSupport::TestCase
  def test_invoke
    Dalia::RailsSkeleton::Tasker.expects(:method_name).returns("RESULT")
    assert_equal("RESULT", Dalia::RailsSkeleton::Tasker.invoke(:method_name))
  end
end

