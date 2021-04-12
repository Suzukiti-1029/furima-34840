require 'rails_helper'

RSpec.describe 'コメント機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @comment = FactoryBot.build(:comment)
  end
  context 'コメントできる時' do
    it 'ログインしたユーザーはコメントでき、内容がすぐに表示される' do
      # ログインする
      sign_in(@item.user)
      # 商品情報詳細ページに遷移する
      visit item_path(@item)
      # コメント欄に記入する
      fill_in 'comment[text]', with: @comment.text
      # 「コメントする」のボタンを押すとCommentモデルのカウントが1上がることを確認する
      expect{click_on('コメントする')}.to change{Comment.count}.by(1)
      # さきほど記入した内容とユーザー名が表示されていることを確認する
      expect(page).to have_content("#{@item.user.nickname}： #{@comment.text}")
    end
  end
  context 'コメントができない時' do
    it 'コメント欄が空だとコメントできない' do
      # ログインする
      sign_in(@item.user)
      # 商品情報詳細ページに遷移する
      visit item_path(@item)
      # 「コメントする」のボタンを押してもCommentモデルのカウントが上がらないことを確認する
      expect{click_on('コメントする')}.to change{Comment.count}.by(0)
      # エラーメッセージが画面に表示されていることを確認する
      @comment.text = ''
      @comment.valid?
      @comment.errors.full_messages.each do |error_message|
        expect(page).to have_content(error_message)
      end
    end
  end
end