require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new(セッションnewがうまく作動するか)" do
    get login_path
    assert_response :success
  end
end
