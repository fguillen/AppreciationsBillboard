require "test_helper"

class AppreciationTest < ActiveSupport::TestCase
  def test_fixture_is_valid
    assert FactoryBot.create(:appreciation).valid?
  end

  def test_uuid_on_create
    appreciation = FactoryBot.build(:appreciation)
    assert_nil(appreciation.uuid)

    appreciation.save!

    assert_not_nil(appreciation.uuid)
  end

  def test_primary_key
    appreciation = FactoryBot.create(:appreciation)

    assert_equal(appreciation, Appreciation.find(appreciation.uuid))
  end

  def test_relations
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciable_user_to_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_to_2 = FactoryBot.create(:appreciable_user)

    appreciation = FactoryBot.create(:appreciation, by: appreciable_user, to: [appreciable_user_to_1, appreciable_user_to_2])

    assert_equal(appreciable_user, appreciation.by)
    assert_equal(appreciable_user_to_1, appreciation.to.first)
    assert_equal(appreciable_user_to_2, appreciation.to.second)
  end

  def test_pic
    appreciation = FactoryBot.create(:appreciation)
    appreciation.pic.attach(io: File.open("#{FIXTURES_PATH}/files/thankyou.gif"), filename: "thankyou.gif")

    puts appreciation.pic.previewable?


    appreciation.pic.attach(io: File.open("#{FIXTURES_PATH}/files/yourule.png"), filename: "yourule.png")

    puts appreciation.pic.previewable?
  end
end
