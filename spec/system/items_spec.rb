require 'rails_helper'

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
      # トップページには先ほど出品した商品の画像、名前、値段、配送料負担オプションがあることを確認する
      item_visible_checker(@item, false)
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
    def set_all_data()
      item = FactoryBot.create(:item)
      user = FactoryBot.create(:user)
      residence_purchase_history = FactoryBot.build(
        :residence_purchase_history,
        user_id: user.id,
        item_id: item.id,
        item_fee: item.fee
      )
      residence_purchase_history.save
      sleep 0.1
    end

    it '画像にsold outの文字が表示されている' do
      # データの準備
      set_all_data()
      # トップページに移動する
      visit root_path
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
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
      商品の全情報、編集・削除ボタン・コメント投稿欄が表示される' do
      # 出品者でログインする
      sign_in(@item.user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 商品の全情報があることを確認する
      item_visible_checker(@item, true)
      # 編集・削除ボタンがあることを確認する
      expect(page).to have_content('商品の編集')
      expect(page).to have_content('削除')
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # コメント投稿欄があることを確認する
      expect(page).to have_selector("form[action='/items/#{@item.id}/comments'][method='post']")
    end

    it 'ログインした出品者でないユーザーは商品詳細ページで、編集・削除ボタンは表示されないが、
      商品の全情報、購入画面遷移ボタン・コメント投稿欄が表示される' do
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 商品の全情報があることを確認する
      item_visible_checker(@item, true)
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
      expect(page).to have_no_content('削除')
      # 購入画面遷移ボタンがあることを確認する
      expect(page).to have_content('購入画面に進む')
      # コメント投稿欄があることを確認する
      expect(page).to have_selector("form[action='/items/#{@item.id}/comments'][method='post']")
    end

    it 'ログインしていない状態では商品詳細ページに遷移でき、商品の全情報は表示されるが、
      編集・削除・購入画面遷移ボタンとコメント投稿欄が表示されない' do
      # トップヘージに移動する
      visit root_path
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 商品の全情報があることを確認する
      item_visible_checker(@item, true)
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
      expect(page).to have_no_content('削除')
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # コメント投稿欄がないことを確認する
      expect(page).to have_selector("form[action='/items/#{@item.id}/comments'][method='post']")
    end
  end

  context '商品が売り切れている時' do
    def set_data(user, item)
      residence_purchase_history = FactoryBot.build(
        :residence_purchase_history,
        user_id: user.id,
        item_id: item.id,
        item_fee: item.fee
      )
      residence_purchase_history.save
      sleep 0.1
    end

    it 'ログインした出品者でも商品詳細ページで、
      編集・削除ボタンが表示されず、sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item)
      # 出品者でログインする
      sign_in(@item.user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_content('商品の編集')
      expect(page).to have_no_content('削除')
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
    it 'ログインした出品者でないユーザーでも商品詳細ページで、
      購入画面遷移ボタンが表示されず、sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item)
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_content('購入画面に進む')
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
    it 'ログインしていない状態では商品詳細ページに遷移でき,sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item)
      # トップヘージに移動する
      visit root_path
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
  end
end