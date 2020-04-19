require "test_helper"

class Front::AppreciableSessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
    assert_template "front/appreciable_sessions/new"
  end
end
