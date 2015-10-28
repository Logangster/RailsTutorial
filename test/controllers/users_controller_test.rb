require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:logan)
    @other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should not edit if not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should not update if not logged in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should not edit if wrong user" do
    login_as @other_user
    get :edit, id: @user
    assert_redirected_to root_path
  end

  test "should not update if wrong user" do
    login_as @other_user
    get :update, id: @user, user: {name: @other_user.name, email: @other_user.email}
    assert_redirected_to root_path
  end

  test "should redirect on index" do
    get :index
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    login_as @other_user
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end
