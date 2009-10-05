require 'test_helper'

class EspaciosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:espacios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create espacio" do
    assert_difference('Espacio.count') do
      post :create, :espacio => { }
    end

    assert_redirected_to espacio_path(assigns(:espacio))
  end

  test "should show espacio" do
    get :show, :id => espacios(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => espacios(:one).to_param
    assert_response :success
  end

  test "should update espacio" do
    put :update, :id => espacios(:one).to_param, :espacio => { }
    assert_redirected_to espacio_path(assigns(:espacio))
  end

  test "should destroy espacio" do
    assert_difference('Espacio.count', -1) do
      delete :destroy, :id => espacios(:one).to_param
    end

    assert_redirected_to espacios_path
  end
end
