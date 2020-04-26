require "test_helper"

class Front::AppreciationsControllerTest < ActionController::TestCase
  def setup
    setup_appreciable_user
  end

  def test_index
    appreciation_1 = FactoryBot.create(:appreciation, created_at: "2020-04-25")
    appreciation_2 = FactoryBot.create(:appreciation, created_at: "2020-04-26")

    get :index

    assert_template "front/appreciations/index"
    assert_primary_keys([appreciation_2, appreciation_1], assigns(:appreciations))
  end

  def test_index_by
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)
    appreciable_user_3 = FactoryBot.create(:appreciable_user)

    appreciation_1 = FactoryBot.create(:appreciation, by: appreciable_user_1, to: [appreciable_user_2, appreciable_user_3])
    appreciation_2 = FactoryBot.create(:appreciation, by: appreciable_user_2, to: [appreciable_user_3])

    get(
      :index,
      params: {
        by: appreciable_user_1
      }
    )

    assert_template "front/appreciations/index"
    assert_primary_keys([appreciation_1], assigns(:appreciations))
  end

  def test_index_to
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)
    appreciable_user_3 = FactoryBot.create(:appreciable_user)

    appreciation_1 = FactoryBot.create(:appreciation, by: appreciable_user_1, to: [appreciable_user_2, appreciable_user_3])
    appreciation_2 = FactoryBot.create(:appreciation, by: appreciable_user_2, to: [appreciable_user_3])

    get(
      :index,
      params: {
        to: appreciable_user_2
      }
    )

    assert_template "front/appreciations/index"
    assert_primary_keys([appreciation_1], assigns(:appreciations))
  end

  def test_show
    appreciation = FactoryBot.create(:appreciation)

    get :show, :params => {:id => appreciation}

    assert_template "front/appreciations/show"
    assert_equal(appreciation, assigns(:appreciation))
  end

  def test_new
    get :new
    assert_template "front/appreciations/new"
    assert_not_nil(assigns(:appreciation))
  end

  def test_create_invalid
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)

    Appreciation.any_instance.stubs(:valid?).returns(false)

    post(
      :create,
      params: {
        appreciation: {
          by_slug: appreciable_user_1,
          message: "message"
        }
      }
    )

    assert_template "new"
    assert_not_nil(flash[:alert])
  end

  def test_create_valid
    appreciable_user_1 = FactoryBot.create(:appreciable_user, name: "Margot Huels")
    appreciable_user_2 = FactoryBot.create(:appreciable_user, name: "Amberly Collier")

    Appreciation.any_instance.expects(:slack_notification)

    post(
      :create,
      params: {
        appreciation: {
          to_names: "#{appreciable_user_1.name}, #{appreciable_user_2.name}",
          message: "Wadus Message longer than 20 chars"
        }
      }
    )

    appreciation = Appreciation.last
    assert_redirected_to [:front, appreciation]

    assert_equal("Wadus Message longer than 20 chars", appreciation.message)
    assert_equal(@appreciable_user, appreciation.by)
    assert_equal(2, appreciation.to.size)
    assert(appreciation.to.include?(appreciable_user_1))
    assert(appreciation.to.include?(appreciable_user_2))
  end

  def test_edit
    appreciation = FactoryBot.create(:appreciation, by: @appreciable_user)

    get :edit, :params => {:id => appreciation}

    assert_template "edit"
    assert_equal(appreciation, assigns(:appreciation))
  end

  def test_update_invalid
    appreciation = FactoryBot.create(:appreciation, by: @appreciable_user)

    Appreciation.any_instance.stubs(:valid?).returns(false)

    put(
      :update,
      params: {
        id: appreciation,
        appreciation: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_template "edit"
    assert_not_nil(flash[:alert])
  end

  def test_update_valid
    appreciation = FactoryBot.create(:appreciation, by: @appreciable_user)

    put(
      :update,
      params: {
        id: appreciation,
        appreciation: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:front, appreciation]
    assert_not_nil(flash[:notice])

    appreciation.reload
    assert_equal("The Wadus Message New", appreciation.message)
  end

  def test_destroy
    appreciation = FactoryBot.create(:appreciation, by: @appreciable_user)

    delete :destroy, :params => {:id => appreciation}

    assert_redirected_to :front_appreciations
    assert_not_nil(flash[:notice])

    assert !Appreciation.exists?(appreciation.id)
  end

  def test_edit_not_allowed
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciation = FactoryBot.create(:appreciation, by: appreciable_user)

    get(
      :edit,
      params: {
        id: appreciation
      }
    )

    assert_redirected_to [:front, appreciation]
    assert_not_nil(flash[:alert])
  end

  def test_update_not_allowed
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciation = FactoryBot.create(:appreciation, by: appreciable_user)

    put(
      :update,
      params: {
        id: appreciation,
        appreciation: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:front, appreciation]
    assert_not_nil(flash[:alert])
  end

  def test_destroy_not_allowed
    appreciable_user = FactoryBot.create(:appreciable_user)
    appreciation = FactoryBot.create(:appreciation, by: appreciable_user)

    delete(
      :destroy,
      params: {
        id: appreciation
      }
    )

    assert_redirected_to [:front, appreciation]
    assert_not_nil(flash[:alert])
  end
end
