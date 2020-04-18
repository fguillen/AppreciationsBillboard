require "test_helper"

class Admin::AppreciationsControllerTest < ActionController::TestCase
  def setup
    setup_admin_user
  end

  def test_index
    appreciation_1 = FactoryBot.create(:appreciation)
    appreciation_2 = FactoryBot.create(:appreciation)

    get :index

    assert_template "admin/appreciations/index"
    assert_ids([appreciation_2, appreciation_1], assigns(:appreciations))
  end

  def test_show
    appreciation = FactoryBot.create(:appreciation)

    get :show, :params => {:id => appreciation}

    assert_template "admin/appreciations/show"
    assert_equal(appreciation, assigns(:appreciation))
  end

  def test_new
    get :new
    assert_template "admin/appreciations/new"
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
    appreciable_user_1 = FactoryBot.create(:appreciable_user)
    appreciable_user_2 = FactoryBot.create(:appreciable_user)

    post(
      :create,
      params: {
        appreciation: {
          by_slug: appreciable_user_1,
          # to: [appreciable_user_2],
          message: "Wadus Message"
        }
      }
    )

    appreciation = Appreciation.last
    assert_redirected_to [:admin, appreciation]

    assert_equal("Wadus Message", appreciation.message)
    assert_equal(appreciable_user_1, appreciation.by)
    # assert_equal(appreciable_user_2, appreciation.to.first)
  end

  def test_edit
    appreciation = FactoryBot.create(:appreciation)

    get :edit, :params => {:id => appreciation}

    assert_template "edit"
    assert_equal(appreciation, assigns(:appreciation))
  end

  def test_update_invalid
    appreciation = FactoryBot.create(:appreciation)

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
    appreciation = FactoryBot.create(:appreciation)

    put(
      :update,
      params: {
        id: appreciation,
        appreciation: {
          message: "The Wadus Message New"
        }
      }
    )

    assert_redirected_to [:admin, appreciation]
    assert_not_nil(flash[:notice])

    appreciation.reload
    assert_equal("The Wadus Message New", appreciation.message)
  end

  def test_destroy
    appreciation = FactoryBot.create(:appreciation)

    delete :destroy, :params => {:id => appreciation}

    assert_redirected_to :admin_appreciations
    assert_not_nil(flash[:notice])

    assert !Appreciation.exists?(appreciation.id)
  end
end