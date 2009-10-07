require 'test_helper'

class TipoespaciosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipoespacios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipoespacio" do
    assert_difference('Tipoespacio.count') do
      post :create, :tipoespacio => { }
    end

    assert_redirected_to tipoespacio_path(assigns(:tipoespacio))
  end

  test "should show tipoespacio" do
    get :show, :id => tipoespacios(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tipoespacios(:one).to_param
    assert_response :success
  end

  test "should update tipoespacio" do
    put :update, :id => tipoespacios(:one).to_param, :tipoespacio => { }
    assert_redirected_to tipoespacio_path(assigns(:tipoespacio))
  end

  test "should destroy tipoespacio" do
    assert_difference('Tipoespacio.count', -1) do
      delete :destroy, :id => tipoespacios(:one).to_param
    end

    assert_redirected_to tipoespacios_path
  end
end
