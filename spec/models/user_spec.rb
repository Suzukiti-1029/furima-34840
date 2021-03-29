require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '登録できる時' do
      it 'nickname、email、password、password_confirmation、last_name、first_name、
      last_name_detail、first_name_detail、birthdayが存在すれば登録できる' do
      end
      it 'password、password_confirmationが英数両方含む6文字以上なら登録できる' do
      end
      it 'last_name、first_nameが全角文字なら登録できる' do
      end
      it 'last_name_detail、first_name_detailが全角カナなら登録できる' do
      end
    end

    context '登録できない時' do
      it 'nicknameが空では登録できない' do
      end
      it 'emailが空では登録できない' do
      end
      it 'emailが重複していれば登録できない' do
      end
      it 'emaiに@がなければ登録できない' do
      end
      it 'passwordが空では登録できない' do
      end
      it 'passwordが英だけでは登録できない' do
      end
      it 'passwordが数だけでは登録できない' do
      end
      it 'passwordが5文字以下では登録できない' do
      end
      it 'passwordがあっても、password_confirmationが空では登録できない' do
      end
      it 'last_nameが空では登録できない' do
      end
      it 'last_nameが半角では登録できない' do
      end
      it 'first_nameが空では登録できない' do
      end
      it 'first_nameが半角では登録できない' do
      end
      it 'last_name_detailが空では登録できない' do
      end
      it 'last_name_detailが全角ひらがなでは登録できない' do
      end
      it 'first_name_detailが空では登録できない' do
      end
      it 'first_name_detailが全角ひらがなでは登録できない' do
      end
      it 'birthdayが空では登録できない' do
      end
    end

  end

end
