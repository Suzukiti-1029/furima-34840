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
      expect(page).to have_link('出品する', href: new_item_path)
      expect(page).to have_link('新規投稿商品', href: new_item_path)
      # 商品出品ページに移動する
      visit new_item_path
      #添付する画像を定義する
      image_path = Rails.root.join('public/images/test_img.png')
      # フォームに情報を入力する
      attach_file('item[image]', image_path)
      item_form_fill(@item)
      # 販売手数料と販売利益が表示されていることを確認する
      expect(page).to have_content((@item.fee * 0.1).ceil)
      expect(page).to have_content((@item.fee * 0.9).floor)
      # 出品するとItemモデルのカウントが1上がることを確認する
      expect{click_on('出品する')}.to change{Item.count}.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # トップページには先ほど出品した商品の画像、名前、値段、配送料負担オプションがあることを確認する
      item_visible_checker(@item, 'test_img.png', false)
    end
  end
  context '商品を出品できない時' do
    it '出品ページで正しく情報が入力されていないと出品できない' do
      # ログインする
      sign_in(@item.user)
      # 商品出品ページに移動する
      visit new_item_path
      # 「出品する」をクリックしてもItemモデルのカウントが上がらないことを確認する
      expect{click_on('出品する')}.to change{Item.count}.by(0)
      # 商品出品ページに戻されることを確認する
      expect(current_path).to eq(items_path)
      # エラーメッセージが画面に表示されていることを確認する
      @item.image = nil
      set_item_empty_data(@item)
      @item.valid?
      @item.errors.full_messages.each do |error_message|
        expect(page).to have_content(error_message)
      end
    end
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
    it '画像にsold outの文字が表示されている' do
      # データの準備
      set_data(nil, nil, true)
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
      item_visible_checker(@item, 'test_img.png', true)
      # 編集・削除ボタンがあることを確認する
      expect(page).to have_link('商品の編集', href: edit_item_path(@item))
      expect(page).to have_link('削除', href: item_path(@item))
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_link('購入画面に進む', href: new_item_residences_path(@item))
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
      item_visible_checker(@item, 'test_img.png', true)
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_link('商品の編集', href: edit_item_path(@item))
      expect(page).to have_no_link('削除', href: item_path(@item))
      # 購入画面遷移ボタンがあることを確認する
      expect(page).to have_link('購入画面に進む', href: new_item_residences_path(@item))
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
      item_visible_checker(@item, 'test_img.png', true)
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_link('商品の編集', href: edit_item_path(@item))
      expect(page).to have_no_link('削除', href: item_path(@item))
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_link('購入画面に進む', href: new_item_residences_path(@item))
      # コメント投稿欄がないことを確認する
      expect(page).to have_selector("form[action='/items/#{@item.id}/comments'][method='post']")
    end
  end
  context '商品が売り切れている時' do
    it 'ログインした出品者でも商品詳細ページで、
      編集・削除ボタンが表示されず、sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item, false)
      # 出品者でログインする
      sign_in(@item.user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 編集・削除ボタンがないことを確認する
      expect(page).to have_no_link('商品の編集', href: edit_item_path(@item))
      expect(page).to have_no_link('削除', href: item_path(@item))
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
    it 'ログインした出品者でないユーザーでも商品詳細ページで、
      購入画面遷移ボタンが表示されず、sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item, false)
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品名をクリックする
      click_on(@item.name)
      # 商品詳細ページへ移動していることを確認する
      expect(current_path).to eq(item_path(@item))
      # 購入画面遷移ボタンがないことを確認する
      expect(page).to have_no_link('購入画面に進む', href: new_item_residences_path(@item))
      # sold outの文字が表示されていることを確認する
      expect(page).to have_content('Sold Out!!')
    end
    it 'ログインしていない状態では商品詳細ページに遷移でき,sold outの文字が表示される' do
      # データの準備
      set_data(@user, @item, false)
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

RSpec.describe '商品情報編集機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  context '商品情報を編集できる時' do
    it 'ログインした出品者は商品を編集でき、編集した情報が反映される' do
      # 編集用のデータを準備
      @item_edit = FactoryBot.build(:item)
      # 出品者でログインする
      sign_in(@item.user)
      # 商品情報編集ページに遷移する
      visit edit_item_path(@item)
      # すでに出品済みの内容がフォームに入っていることを確認する
      expect(find('#item-name').value).to eq(@item.name)
      expect(find('#item-info').value).to eq(@item.describe)
      expect(find('#item-category').value.to_i).to eq(@item.category_id)
      expect(find('#item-sales-status').value.to_i).to eq(@item.situation_id)
      expect(find('#item-shipping-fee-status').value.to_i).to eq(@item.fare_option_id)
      expect(find('#item-prefecture').value.to_i).to eq(@item.prefecture_id)
      expect(find('#item-scheduled-delivery').value.to_i).to eq(@item.need_days_id)
      expect(find('#item-price').value.to_i).to eq(@item.fee)
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_edit_img.jpg')
      # 投稿内容を編集する
      attach_file('item[image]', image_path)
      item_form_fill(@item_edit)
      # 「変更する」ボタンもItemモデルのカウントは変わらないことを確認する
      expect{click_on('変更する')}.to change{Item.count}.by(0)
      # 商品詳細ページに遷移したことを確認する
      expect(current_path).to eq(item_path(@item))
      # 詳細ページには先ほど変更した内容の商品の全情報が存在することを確認する
      item_visible_checker(@item_edit, 'test_edit_img.jpg', true)
    end
    it '編集しなくても画像なしの商品にならない' do
      # 出品者でログインする
      sign_in(@item.user)
      # 商品情報編集ページに遷移する
      visit edit_item_path(@item)
      # 「変更する」ボタンもItemモデルのカウントは変わらないことを確認する
      expect{click_on('変更する')}.to change{Item.count}.by(0)
      # 商品詳細ページに遷移したことを確認する
      expect(current_path).to eq(item_path(@item))
      # 詳細ページには先ほどと同じ内容の商品の全情報が存在することを確認する
      item_visible_checker(@item, 'test_img.png', true)
    end
  end
  context '商品情報を編集できない時' do
    it '編集ページで正しく情報が入力されていないと編集できない' do
      # 編集用のデータを準備
      set_item_empty_data(@item)
      # 出品者でログインする
      sign_in(@item.user)
      # 商品情報編集ページに遷移する
      visit edit_item_path(@item)
      # 投稿内容を編集する
      item_form_fill(@item)
      # 「変更する」ボタンを押してもItemモデルのカウントは変わらないことを確認する
      expect{click_on('変更する')}.to change{Item.count}.by(0)
      # 商品情報編集ページに戻されることを確認する
      expect(current_path).to eq(item_path(@item))
      # エラーメッセージが画面に表示されていることを確認する
      @item.valid?
      @item.errors.full_messages.each do |error_message|
        expect(page).to have_content(error_message)
      end
    end
    it 'ログインした出品者でないユーザーは商品情報編集ページに遷移できない' do
      # 出品者でないユーザーでログインする
      sign_in(@user)
      # 商品情報編集ページに遷移しようとする
      visit edit_item_path(@item)
      # トップページに戻されることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないユーザーは商品情報編集ページに遷移できない' do
      # 商品情報編集ページに遷移しようとする
      visit edit_item_path(@item)
      # ログインページに飛ばされることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
    it 'ログインした出品者でも、売り切れの商品情報編集ページには遷移できない' do
      # データの準備
      set_data(@user, @item, false)
      # 出品者でログインする
      sign_in(@item.user)
      # 商品情報編集ページに遷移しようとする
      visit edit_item_path(@item)
      # トップページに戻されることを確認する
      expect(current_path).to eq(root_path)
    end
  end
end

RSpec.describe '商品削除機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
  end
  it 'ログインした出品者は商品を削除できる' do
    # 出品者でログインする
    sign_in(@item.user)
    # 商品詳細ページへ遷移する
    visit item_path(@item)
    # 「削除」ボタンをクリックするとItemモデルのレコードの数が1減ることを確認する
    expect{click_on('削除')}.to change{Item.count}.by(-1)
    # トップページに遷移したことを確認する
    expect(current_path).to eq(root_path)
    # トップページには削除した商品の全情報がないことを確認する
    item_invisible_checker(@item, 'test_img.png')
  end
end