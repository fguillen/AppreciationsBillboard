require "test_helper"

class AuthorizationTest < ActiveSupport::TestCase
  def test_find_from_omniauth_data
    authorization_1 = FactoryBot.create(:authorization, :uid => "01")
    authorization_2 = FactoryBot.create(:authorization, :uid => "02")

    assert_equal(authorization_1.id, Authorization.find_from_omniauth_data({"provider" => "google_oauth2","uid" => "01"}).id )
    assert_equal(authorization_2.id, Authorization.find_from_omniauth_data({"provider" => "google_oauth2","uid" => "02"}).id )
  end
end
