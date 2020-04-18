require "test_helper"

class TaskerTest < ActiveSupport::TestCase
  def test_invoke
    Dalia::AppreciationsBillboard::Tasker.expects(:method_name).returns("RESULT")
    assert_equal("RESULT", Dalia::AppreciationsBillboard::Tasker.invoke(:method_name))
  end
end
