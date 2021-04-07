require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '商品出品機能', type: :system do
  before do
    @item = FactoryBot.build(:item)
    @item.user.save
  end
  context '商品を出品できる時' do
    it 'ログインしたユーザーは商品を出品できる' do
      # ログインする
      sign_in(@item.user)
      # 商品出品ページへのリンクがあることを確認する
      expect(page).to have_content('出品する')
      expect(page).to have_content('新規投稿商品')
      # 商品出品ページに移動する
      visit new_item_path
      #添付する画像を定義する
      image_path = Rails.root.join('public/images/test_img.png')
      # フォームに情報を入力する
      attach_file('item[image]', image_path)
      fill_in 'item[name]', with: @item.name
      fill_in 'item[describe]', with: @item.describe
      select @item.category.name, from: 'item[category_id]'
      select @item.situation.name, from: 'item[situation_id]'
      select @item.fare_option.name, from: 'item[fare_option_id]'
      select @item.prefecture.name, from: 'item[prefecture_id]'
      select @item.need_days.name, from: 'item[need_days_id]'
      fill_in 'item[fee]', with: @item.fee
      # 販売手数料と販売利益が表示されていることを確認する
      expect(page).to have_content((@item.fee * 0.1).ceil)
      expect(page).to have_content((@item.fee * 0.9).floor)
      # 出品するとItemモデルのカウントが1上がることを確認する
      expect{click_on('出品する')}.to change{Item.count}.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # トップページには先ほど出品した商品の画像があることを確認する
      expect(page).to have_selector("img[src$='test_img.png']")
      # トップページには先ほど出品した商品の名前があることを確認する
      expect(page).to have_content(@item.name)
      # トップページには先ほど出品した商品の値段があることを確認する
      expect(page).to have_content(@item.fee)
      # トップページには先ほど出品した商品の配送料負担オプションがあることを確認する
      expect(page).to have_content(@item.fare_option.name)
    end
  end
  context '商品を出品できない時' do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # 商品出品ページに遷移しようとする
      visit new_item_path
      # ログインページに飛ばされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '商品一覧機能', type: :system do
  context '商品が出品されていない時' do
    it 'ダミーの商品が表示されている' do
      # トップページに移動する
      basic_pass(root_path)
      # トップページにダミー商品の画像があることを確認する
      expect(page).to have_selector("img[src$='sample.jpg']")
      # トップページにダミー商品の名前があることを確認する
      expect(page).to have_content('商品を出品してね！')
      # トップページにダミー商品の値段があることを確認する
      expect(page).to have_content('99999999円')
      # トップページにダミー商品の配送料負担オプションがあることを確認する
      expect(page).to have_content('(税込み)')
    end
  end
  context '商品が売り切れている時' do
    # データの準備
    item = FactoryBot.create(:item)
    user = FactoryBot.create(:user)
    residence_purchase_history = FactoryBot.build(
      :residence_purchase_history,
      user_id: user.id,
      item_id: item.id,
      item_fee: item.fee
    )
    residence_purchase_history.save

    it '画像にsold outの文字が表示されている' do
      # トップページに移動する
      visit root_path
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
      binding.pry
    end
  end
end


RSpec.describe '商品詳細表示機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  context '商品が売り切れていない時' do
    it 'ログインした出品者は商品詳細ページで、購入画面遷移ボタンは表示されないが、
      編集・削除ボタン・コメント投稿欄が表示される' do
      # 出品者でログインする
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # 編集・削除ボタンがあることを確認する
      # 購入画面遷移ボタンがないことを確認する
      # コメント投稿欄があることを確認する
    end

    it 'ログインした出品者でないユーザーは商品詳細ページで、編集・削除ボタンは表示されないが、
      購入画面遷移ボタン・コメント投稿欄が表示される' do
      # 出品者でないユーザーでログインする
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # 編集・削除ボタンがないことを確認する
      # 購入画面遷移ボタンがあることを確認する
      # コメント投稿欄があることを確認する
    end

    it 'ログインしていない状態では商品詳細ページに遷移できるが、
      編集・削除・購入画面遷移ボタンとコメント投稿欄が表示されない' do
      # トップヘージに移動する
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # 編集・削除ボタンがないことを確認する
      # 購入画面遷移ボタンがないことを確認する
      # コメント投稿欄がないことを確認する
    end
  end

  context '商品が売り切れている時' do
    # データの準備
    residence_purchase_history = FactoryBot.build(
      :residence_purchase_history,
      user_id: @user.id,
      item_id: @item.id,
      item_fee: @item.fee
    )
    residence_purchase_history.save

    it 'ログインした出品者でも商品詳細ページで、
      編集・削除ボタンが表示されず、sold outの文字が表示される' do
      # 出品者でログインする
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # 編集・削除ボタンがないことを確認する
      # sold outの文字が表示されていることを確認する
    end
    it 'ログインした出品者でないユーザーでも商品詳細ページで、
      購入画面遷移ボタンが表示されず、sold outの文字が表示される' do
      # 出品者でないユーザーでログインする
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # 購入画面遷移ボタンがないことを確認する
      # sold outの文字が表示されていることを確認する
    end
    it 'ログインしていない状態では商品詳細ページに遷移でき,sold outの文字が表示される' do
      # トップヘージに移動する
      # 商品名をクリックする
      # 商品詳細ページへ移動していることを確認する
      # sold outの文字が表示されていることを確認する
    end
  end
end