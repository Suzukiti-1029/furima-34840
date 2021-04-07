require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      basic_pass(root_path)
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password_confirmation
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name_detail]', with: @user.last_name_detail
      fill_in 'user[first_name_detail]', with: @user.first_name_detail
      select @user.birthday.year, from: 'user[birthday(1i)]'
      select @user.birthday.month, from: 'user[birthday(2i)]'
      select @user.birthday.day, from: 'user[birthday(3i)]'
      # サインアップボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect{click_on('会員登録')}.to change{User.count}.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ログアウトボタンが表示されていることを確認する
      expect(page).to have_content('ログアウト')
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      basic_pass(root_path)
      # トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{click_on('会員登録')}.to change{User.count}.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq(user_registration_path)
      # エラーメッセージが画面に表示されていることを確認する
      @user.nickname = ''
      @user.email = ''
      @user.password = ''
      @user.password_confirmation = ''
      @user.last_name = ''
      @user.first_name = ''
      @user.last_name_detail = ''
      @user.first_name_detail = ''
      @user.birthday = nil
      @user.valid?
      @user.errors.full_messages.each do |error_message|
        expect(page).to have_content(error_message)
      end
    end
  end
end

RSpec.describe 'ユーザーログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it '保存されているユーザーの情報と一致すればログインができてトップページに移動する' do
      # トップページに移動する
      # トップページにログインページへ遷移するボタンがあることを確認する
      # ログインページへ移動する
      # ユーザー情報を入力する
      # ログインボタンを押す
      # トップページへ遷移したことを確認する
      # ログアウトボタンが表示されていることを確認する
      # サインアップページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
    end
  end
  context 'ログインができないとき' do
    it '保存されているユーザーの情報と一致しないとログインができずにログインページへ戻ってくる' do
      # トップページに移動する
      # トップページにログインページへ遷移するボタンがあることを確認する
      # ログインページへ移動する
      # ログインボタンを押す
      # ログインページへ戻されることを確認する
      # エラーメッセージが画面に表示されていることを確認する
    end
  end
end