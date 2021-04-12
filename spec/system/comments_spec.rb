require 'rails_helper'

RSpec.describe 'コメント機能', type: :system do
  before do
    @item = FactoryBot.create(:item)
    @comment = FactoryBot.build(:comment)
  end
  context 'コメントできる時' do
    it 'ログインしたユーザーはコメントでき、内容がすぐに表示される' do
      # ログインする
      # 商品情報詳細ページに遷移する
      # コメント欄に記入する
      # 「コメントする」のボタンを押すとCommentモデルのカウントが1上がることを確認する
      # さきほど記入した内容とユーザー名が表示されていることを確認する
    end
  end
  context 'コメントができない時' do
    it 'コメント欄が空だとコメントできない' do
      # ログインする
      # 商品情報詳細ページに遷移する
      # 「コメントする」のボタンを押してもCommentモデルのカウントが上がらないことを確認する
      # エラーメッセージが画面に表示されていることを確認する
    end
  end
end