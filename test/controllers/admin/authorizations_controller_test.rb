require "test_helper"

class Admin::AuthorizationsControllerTest < ActionController::TestCase

  def test_create_when_user_already_authorized
    admin_user = FactoryBot.create(:admin_user)
    authorization = FactoryBot.create(:authorization, :admin_user => admin_user)
    Authorization.expects(:find_from_omniauth_data).returns(authorization)
    AdminUserSession.expects(:create).with(admin_user,true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :admin_root
  end

  def test_create_when_user_not_yet_authorized_and_email_present
    admin_user = FactoryBot.create(:admin_user, :email => "john@email.com")
    Authorization.expects(:find_from_omniauth_data).returns(nil)
    AdminUserSession.expects(:create).with(admin_user,true)

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :admin_root
  end

  def test_create_when_user_not_yet_authorized_and_email_not_present
    admin_user = FactoryBot.create(:admin_user, :email => "john@anotherprovider.com")
    Authorization.expects(:find_from_omniauth_data).returns(nil)
    AdminUserSession.expects(:create).with(admin_user,true).never

    @request.env["omniauth.auth"] = JSON.parse(read_fixture("google_auth_response.json"),:symbolize_names => true)

    get :create, :params => { :provider => "google_oauth2" }

    assert_response 302
    assert_redirected_to :new_admin_admin_user_session
  end
end
