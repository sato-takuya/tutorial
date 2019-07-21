require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "indexアクションが正しくリダイレクトするか検証するテスト" do
    get users_path
    assert_redirected_to login_url
  end
end
