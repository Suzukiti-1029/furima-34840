require 'rails_helper'

RSpec.describe '商品購入機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
    @residence_purchase_history = FactoryBot.build(
      :residence_purchase_history,
      user_id: @user.id,
      item_id: @item.id,
      item_fee: @item.fee
    )
  end
  context '商品を購入できる時' do
    it 'ログインした出品者でないユーザーは商品を購入できる' do
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品購入ページに遷移する
      visit new_item_residences_path(@item)
      # 必須情報を入力する
      fill_in 'residence_purchase_history[number]',
        with: 4242424242424242
      fill_in 'residence_purchase_history[exp_month]',
        with: 3
      fill_in 'residence_purchase_history[exp_year]',
        with: 23
      fill_in 'residence_purchase_history[cvc]',
        with: 123
      fill_in 'residence_purchase_history[area_number]',
        with: @residence_purchase_history.area_number
      select Prefecture.find(
        @residence_purchase_history.prefecture_id
        )[:name], from: 'residence_purchase_history[prefecture_id]'
      fill_in 'residence_purchase_history[city]',
        with: @residence_purchase_history.city
      fill_in 'residence_purchase_history[address]',
        with: @residence_purchase_history.address
      fill_in 'residence_purchase_history[building]',
        with: @residence_purchase_history.building
      fill_in 'residence_purchase_history[phone_number]',
        with: @residence_purchase_history.phone_number
      # 「購入する」ボタンをクリックするとResidenceモデルとPurchase_historyモデルのカウントが1上がることを確認する
      before_residence_count = Residence.count
      before_purchase_history_count = PurchaseHistory.count
      click_on('購入')
      sleep 3.0
      expect(Residence.count - before_residence_count).to eq(1)
      expect(PurchaseHistory.count - before_purchase_history_count).to eq(1)
      # 購入完了ページに遷移したことを確認する
      expect(current_path).to eq(item_residences_path(@item))
      # トップページに遷移する
      visit root_path
      # 購入した商品にSold Outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
  end
  context '商品を購入できない時' do
    it '購入ページで正しく情報が入力されていないと購入できない' do
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品購入ページに遷移する
      visit new_item_residences_path(@item)
      # 「購入する」ボタンをクリックしてもResidenceモデルとPurchase_historyモデルのカウントが1上がらないことを確認する
      before_residence_count = Residence.count
      before_purchase_history_count = PurchaseHistory.count
      click_on('購入')
      sleep 3.0
      expect(Residence.count - before_residence_count).to eq(0)
      expect(PurchaseHistory.count - before_purchase_history_count).to eq(0)
      # 購入ページに戻されることを確認する
      expect(current_path).to eq(item_residences_path(@item))
      # エラーメッセージが画面に表示されていることを確認する
      @residence_purchase_history.area_number = ''
      @residence_purchase_history.prefecture_id = 1
      @residence_purchase_history.city = ''
      @residence_purchase_history.address = ''
      @residence_purchase_history.phone_number = ''
      @residence_purchase_history.token = ''
      @residence_purchase_history.valid?
      @residence_purchase_history.errors.full_messages.each do |error_message|
        expect(page).to have_content(error_message)
      end
    end
    it 'ログインした出品者は商品購入ページに遷移できない' do
      # 出品者でログインする
      sign_in(@item.user)
      # 商品購入ページに遷移しようとする
      visit new_item_residences_path(@item)
      # トップページに戻されることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないと商品購入ページに遷移できない' do
      # 商品購入ページに遷移しようとする
      visit new_item_residences_path(@item)
      # ログインページに飛ばされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it 'ログインした出品者でないユーザーでも売り切れの商品購入ページには遷移できない' do
      # データの準備
      @residence_purchase_history.save
      sleep 0.1
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品購入ページに遷移しようとする
      visit new_item_residences_path(@item)
      # トップページに戻されることを確認する
      expect(current_path).to eq(root_path)
    end
  end
end