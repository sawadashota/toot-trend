require 'test_helper'

class TootsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @toot = toots(:one)
  end

  test "should get index" do
    get toots_url
    assert_response :success
  end

  test "should get new" do
    get new_toot_url
    assert_response :success
  end

  test "should create toot" do
    assert_difference('Toot.count') do
      post toots_url, params: { toot: {  } }
    end

    assert_redirected_to toot_url(Toot.last)
  end

  test "should show toot" do
    get toot_url(@toot)
    assert_response :success
  end

  test "should get edit" do
    get edit_toot_url(@toot)
    assert_response :success
  end

  test "should update toot" do
    patch toot_url(@toot), params: { toot: {  } }
    assert_redirected_to toot_url(@toot)
  end

  test "should destroy toot" do
    assert_difference('Toot.count', -1) do
      delete toot_url(@toot)
    end

    assert_redirected_to toots_url
  end
end
