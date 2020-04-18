require "test_helper"

class AppreciableUserTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:appreciable_user).valid?
  end

  def test_slug_on_create
    appreciable_user = FactoryBot.build(:appreciable_user, name: "Appreciable User Title")
    assert_nil(appreciable_user.slug)

    appreciable_user.save!

    assert_equal("appreciable-user-title", appreciable_user.slug)
  end

  def test_primary_key
    appreciable_user = FactoryBot.create(:appreciable_user)

    assert_equal(appreciable_user, AppreciableUser.find(appreciable_user.slug))
  end
end
