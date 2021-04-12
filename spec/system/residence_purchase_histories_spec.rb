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
      # 商品購入ページに遷移する
      # 購入ページへ移動したことを確認する
      # 必須情報を入力する
      # 「購入する」ボタンをクリックするとResidenceモデルとPurchase_historyモデルのカウントが1上がることを確認する
      # 購入完了ページに遷移したことを確認する
      # トップページに遷移する
      # 購入した商品にSold Outの文字が表示されていることを確認する
    end
  end
  context '商品を購入できない時' do
    it '購入ページで正しく情報が入力されていないと購入できない' do
      # 出品者でないユーザーでログインする
      # 商品購入ページに遷移する
      # 購入ページへ移動したことを確認する
      # 「購入する」ボタンをクリックしてもResidenceモデルとPurchase_historyモデルのカウントが1上がらないことを確認する
      # 購入ページに戻されることを確認する
      # エラーメッセージが画面に表示されていることを確認する
    end
    it 'ログインした出品者は商品購入ページに遷移できない' do
      # 出品者でログインする
      # 商品購入ページに遷移しようとする
      # トップページに戻されることを確認する
    end
    it 'ログインしていないと商品購入ページに遷移できない' do
      # 商品購入ページに遷移しようとする
      # ログインページに飛ばされることを確認する
    end
    it 'ログインした出品者でないユーザーでも売り切れの商品購入ページには遷移できない' do
      # データの準備
      @residence_purchase_history.save
      sleep 0.1
      # 出品者でないユーザーでログインする
      # 商品購入ページに遷移しようとする
      # トップページに戻されることを確認する
    end
  end
end