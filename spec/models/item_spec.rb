require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品機能' do
    context '出品ができる時' do
      it '情報がすべて正しく入力されていれば出品できる' do
        expect(@item).to be_valid
      end
      it 'category_idが1以外なら出品できる' do
        @item.category_id = 2
        expect(@item).to be_valid
      end
      it 'situation_idが1以外なら出品できる' do
        @item.situation_id = 2
        expect(@item).to be_valid
      end
      it 'fare_option_idが1以外なら出品できる' do
        @item.fare_option_id = 2
        expect(@item).to be_valid
      end
      it 'prefecture_idが1以外なら出品できる' do
        @item.prefecture_id = 2
        expect(@item).to be_valid
      end
      it 'need_days_idが1以外なら出品できる' do
        @item.need_days_id = 2
        expect(@item).to be_valid
      end
      it 'feeが300以上の整数であれば登録できる' do
        @item.fee = 300
        expect(@item).to be_valid
      end
      it 'feeが9999999以下の整数であれば登録できる' do
        @item.fee = 9999999
        expect(@item).to be_valid
      end
    end

    context '出品ができない時' do
      it 'imageが紐付いてなければ出品できない' do
        @item.image = nil
        @item.valid?

        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
      it 'nameが空では出品できない' do
        @item.name = ''
        @item.valid?

        expect(@item.errors.full_messages).to include("Name can't be blank")
      end
      it 'describeが空では出品できない' do
        @item.describe = ''
        @item.valid?

        expect(@item.errors.full_messages).to include("Describe can't be blank")
      end
      it 'category_idが1では出品できない' do
        @item.category_id = 1
        @item.valid?

        expect(@item.errors.full_messages).to include('Category must be other than 1')
      end
      it 'situation_idが1では出品できない' do
        @item.situation_id = 1
        @item.valid?

        expect(@item.errors.full_messages).to include('Situation must be other than 1')
      end
      it 'fare_option_idが1では出品できない' do
        @item.fare_option_id = 1
        @item.valid?

        expect(@item.errors.full_messages).to include('Fare option must be other than 1')
      end
      it 'prefecture_idが1では出品できない' do
        @item.prefecture_id = 1
        @item.valid?

        expect(@item.errors.full_messages).to include('Prefecture must be other than 1')
      end
      it 'need_days_idが1では出品できない' do
        @item.need_days_id = 1
        @item.valid?

        expect(@item.errors.full_messages).to include('Need days must be other than 1')
      end
      it 'feeが空では出品できない' do
        @item.fee = ''
        @item.valid?

        expect(@item.errors.full_messages).to include("Fee can't be blank")
      end
      it 'feeが小数だと出品できない' do
        @item.fee = 300.0
        @item.valid?

        expect(@item.errors.full_messages).to include('Fee must be an integer')
      end
      it 'feeが全角数字だと出品できない' do
        @item.fee = '３００'
        @item.valid?

        expect(@item.errors.full_messages).to include('Fee is not a number')
      end
      it 'feeがマイナスだと出品できない' do
        @item.fee = -1
        @item.valid?

        expect(@item.errors.full_messages).to include('Fee must be greater than or equal to 300')
      end
      it 'feeが300未満では出品できない' do
        @item.fee = 299
        @item.valid?

        expect(@item.errors.full_messages).to include('Fee must be greater than or equal to 300')
      end
      it 'feeが9999999より大きいならば出品できない' do
        @item.fee = 10000000
        @item.valid?

        expect(@item.errors.full_messages).to include('Fee must be less than or equal to 9999999')
      end
    end
  end
end
