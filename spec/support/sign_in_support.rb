module SignInSupport
  def sign_in(user)
    basic_pass(new_user_session_path)
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_on('ログイン')
    expect(current_path).to eq(root_path)
  end
end