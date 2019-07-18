require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",password: "foobar", password_confirmation: "foobar")
  end

  test "sould be valid" do
    assert @user.valid?
  end

  #処理が失敗すれば(ちゃんとバリデーションに引っかかれば)テストに通る
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should notbe too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should notbe too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email should be accept address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?,"#{valid_address.inspect} should be valid"
    end
  end

  #無効なアドレス
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "emailがユニークでなければならない 処理が失敗すれば(ちゃんとバリデーションに引っかかれば)テストに通る" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "passwordが空ではならない　処理が失敗すれば(ちゃんとバリデーションに引っかかれば)テストに通る" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passwordは5文字以下ではならない" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end