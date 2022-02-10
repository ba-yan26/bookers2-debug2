class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    # user.rbでguestメソッドを定義しているのでそれを持ってきている
    sign_in user
    # ゲストユーザーをログイン状態にする
    redirect_to user_path(user), notice: 'guestuserでログインしました。'
    # 遷移先をゲストユーザーの詳細ページへ設定
  end
end