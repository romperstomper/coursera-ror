require 'test_helper'

class TodolistsControllerTest < ActionController::TestCase
  setup do
    @todolist = todolists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:todolists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create todolist" do
    assert_difference('Todolist.count') do
      post :create, todolist: { list_due_date: @todolist.list_due_date, list_name: @todolist.list_name }
    end

    assert_redirected_to todolist_path(assigns(:todolist))
  end

  test "should show todolist" do
    get :show, id: @todolist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @todolist
    assert_response :success
  end

  test "should update todolist" do
    patch :update, id: @todolist, todolist: { list_due_date: @todolist.list_due_date, list_name: @todolist.list_name }
    assert_redirected_to todolist_path(assigns(:todolist))
  end

  test "should destroy todolist" do
    assert_difference('Todolist.count', -1) do
      delete :destroy, id: @todolist
    end

    assert_redirected_to todolists_path
  end
end
