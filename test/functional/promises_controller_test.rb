require 'test_helper'

class PromisesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:promises)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_promise
    assert_difference('Promise.count') do
      post :create, :promise => { }
    end

    assert_redirected_to promise_path(assigns(:promise))
  end

  def test_should_show_promise
    get :show, :id => promises(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => promises(:one).id
    assert_response :success
  end

  def test_should_update_promise
    put :update, :id => promises(:one).id, :promise => { }
    assert_redirected_to promise_path(assigns(:promise))
  end

  def test_should_destroy_promise
    assert_difference('Promise.count', -1) do
      delete :destroy, :id => promises(:one).id
    end

    assert_redirected_to promises_path
  end
end
