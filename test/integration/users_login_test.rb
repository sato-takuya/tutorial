require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'flashがうまく表示されて、かつうまく消えるかどうか' do
    get login_path
    assert_template 'sessions/new'
    post login_path,params:{session:{email:"",password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty? #フラッシュメッセージが空ではないよね
    get root_path
    assert flash.empty? #フラッシュメッセージは空だよね？
  end

  test 'ログイン後のリンクがうまく表示できているかテスト' do
    get login_path
    post login_path,params:{session: {email: @user.email,password: 'password'}} #ログイン
    assert_redirected_to @user #ユーザーのマイページ
    follow_redirect! #そのページへ実際に飛ぶと
    assert_template 'users/show' #ユーザーのマイページが表示されるか
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

   test "ログアウトテスト" do
    get login_path
    post login_path, params: { session: { email:    @user.email,password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test "チェックボックスつけてログイン" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "チェックボックスつけてログイン、ログアウト。つけずにログイン、ログアウト" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
