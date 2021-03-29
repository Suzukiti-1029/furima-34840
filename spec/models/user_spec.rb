require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '登録できる時' do
      it 'nickname、email、password、password_confirmation、last_name、first_name、
          last_name_detail、first_name_detail、birthdayが存在すれば登録できる' do
        expect(@user).to be_valid
      end
      it 'password、password_confirmationが英数両方含む6文字以上なら登録できる' do
        @user.password = 'aaa111'
        @user.password_confirmation = 'aaa111'
        expect(@user).to be_valid
      end
      it 'last_name、first_nameが全角文字なら登録できる' do
        @user.last_name = 'あ'
        @user.first_name = 'あ'
        expect(@user).to be_valid
      end
      it 'last_name_detail、first_name_detailが全角カナなら登録できる' do
        @user.last_name_detail = 'ア'
        @user.first_name_detail = 'ア'
        expect(@user).to be_valid
      end
    end

    context '登録できない時' do
      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it 'emailが重複していれば登録できない' do
        @another_user = FactoryBot.create(:user)
        @user.email = @another_user.email
        @user.valid?
        expect(@user.errors.full_messages).to include('Email has already been taken')
      end
      it 'emaiに@がなければ登録できない' do
        @user.email = 'a'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end
      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが英だけでは登録できない' do
        @user.password = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password には英字と数字の両方を含めて設定してください')
      end
      it 'passwordが数だけでは登録できない' do
        @user.password = '111111'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password には英字と数字の両方を含めて設定してください')
      end
      it 'passwordが5文字以下では登録できない' do
        @user.password = 'aaa11'
        @user.valid?
        expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
      it 'passwordがあっても、password_confirmationが空では登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end
      it 'last_nameが空では登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end
      it 'last_nameが半角では登録できない' do
        @user.last_name = 'ｱ'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name 全角文字を使用してください')
      end
      it 'first_nameが空では登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end
      it 'first_nameが半角では登録できない' do
        @user.first_name = 'ｱ'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name 全角文字を使用してください')
      end
      it 'last_name_detailが空では登録できない' do
        @user.last_name_detail = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name detail can't be blank")
      end
      it 'last_name_detailが全角ひらがなでは登録できない' do
        @user.last_name_detail = 'あ'
        @user.valid?
        expect(@user.errors.full_messages).to include('Last name detail 全角カタカナを使用してください')
      end
      it 'first_name_detailが空では登録できない' do
        @user.first_name_detail = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("First name detail can't be blank")
      end
      it 'first_name_detailが全角ひらがなでは登録できない' do
        @user.first_name_detail = 'あ'
        @user.valid?
        expect(@user.errors.full_messages).to include('First name detail 全角カタカナを使用してください')
      end
      it 'birthdayが空では登録できない' do
        @user.birthday = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Birthday can't be blank")
      end
    end
  end
end
