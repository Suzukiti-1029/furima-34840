require 'rails_helper'

RSpec.describe ResidencePurchaseHistory, type: :model do
  before do
    item = FactoryBot.create(:item)
    user = FactoryBot.create(:user)
    @residence_purchase_history = FactoryBot.build(
      :residence_purchase_history,
      user_id: user.id,
      item_id: item.id,
      item_fee: item.fee
    )
  end

  describe '商品購入機能' do
    context '購入できる時' do
      it '情報が全て正しく入力・存在されていれば購入できる' do
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
      it 'area_numberが3ケタの半角数字と半角ハイフン(-)、4ケタの半角数字を続けて入力していれば購入できる' do
        @residence_purchase_history.area_number = '000-0000'
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
      it 'prefecture_idが1以外なら購入できる' do
        @residence_purchase_history.prefecture_id = 2
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
      it 'buildingが空でも購入できる' do
        @residence_purchase_history.building = ''
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
      it 'phone_numberが10ケタの半角数字なら購入できる' do
        @residence_purchase_history.phone_number = '1234567890'
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
      it 'phone_numberが11ケタの半角数字なら購入できる' do
        @residence_purchase_history.phone_number = '12345678901'
        expect(@residence_purchase_history).to be_valid
        sleep 3.0
      end
    end

    context '購入できない時' do
      it 'area_numberが空では購入できない' do
        @residence_purchase_history.area_number = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Area number can't be blank")
        sleep 3.0
      end
      it 'area_numberが7ケタの半角数字のみでは購入できない' do
        @residence_purchase_history.area_number = '1234567'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Area number 3ケタの半角数字、半角ハイフン(-)、4ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'area_numberが3ケタの全角数字と半角ハイフン(-)、4ケタの全角数字では購入できない' do
        @residence_purchase_history.area_number = '１２３-４５６７'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Area number 3ケタの半角数字、半角ハイフン(-)、4ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'area_numberが半角英数では購入できない' do
        @residence_purchase_history.area_number = '123a567'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Area number 3ケタの半角数字、半角ハイフン(-)、4ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'area_numberが半角英のみでは購入できない' do
        @residence_purchase_history.area_number = 'abcdefg'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Area number 3ケタの半角数字、半角ハイフン(-)、4ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'prefecture_idが空では購入できない' do
        @residence_purchase_history.prefecture_id = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Prefecture is not a number')
        sleep 3.0
      end
      it 'prefecture_idが1では購入できない' do
        @residence_purchase_history.prefecture_id = 1
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Prefecture must be other than 1')
        sleep 3.0
      end
      it 'cityが空では購入できない' do
        @residence_purchase_history.city = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("City can't be blank")
        sleep 3.0
      end
      it 'addressが空では購入できない' do
        @residence_purchase_history.address = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Address can't be blank")
        sleep 3.0
      end
      it 'phone_numberが空では購入できない' do
        @residence_purchase_history.phone_number = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Phone number can't be blank")
        sleep 3.0
      end
      it 'phone_numberが9ケタ以下の半角数字では購入できない' do
        @residence_purchase_history.phone_number = '123456789'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'phone_numberが12ケタ以上の半角数字では購入できない' do
        @residence_purchase_history.phone_number = '123456789012'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'phone_numberが10ケタの全角数字では購入できない' do
        @residence_purchase_history.phone_number = '１２３４５６７８９０'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'phone_numberが11ケタの全角数字では購入できない' do
        @residence_purchase_history.phone_number = '１２３４５６７８９０１'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'phone_numberが半角英数では購入できない' do
        @residence_purchase_history.phone_number = '12345a7890'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'phone_numberが半角英のみでは購入できない' do
        @residence_purchase_history.phone_number = 'abcdefghij'
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include('Phone number 10ケタか11ケタの半角数字を続けて入力してください')
        sleep 3.0
      end
      it 'user_idが空では購入できない' do
        @residence_purchase_history.user_id = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("User can't be blank")
        sleep 3.0
      end
      it 'item_idが空では購入できない' do
        @residence_purchase_history.item_id = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Item can't be blank")
        sleep 3.0
      end
      it 'item_feeが空では購入できない' do
        @residence_purchase_history.item_fee = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Item fee can't be blank")
        sleep 3.0
      end
      it 'tokenが空では購入できない' do
        @residence_purchase_history.token = ''
        @residence_purchase_history.valid?
        expect(@residence_purchase_history.errors.full_messages).to include("Token can't be blank")
        sleep 3.0
      end
    end
  end
end
