require 'rails_helper'

def basic_pass(path)
  username = ENV['BASIC_AUTH_USER']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe '商品出品機能', type: :system do
  before do
    @item = FactoryBot.build(:item)
  end
  context '商品を出品できる時' do
    it 'ログインしたユーザーは商品を出品できる' do
      # ログインする
      # 商品出品ページへのリンクがあることを確認する
      # 商品出品ページに移動する
      # フォームに情報を入力する
      # 出品するとItemモデルのカウントが1上がることを確認する
      # トップページに遷移することを確認する
      # トップページには先ほど出品した商品の画像があることを確認する
      # トップページには先ほど出品した商品の名前があることを確認する
      # トップページには先ほど出品した商品の値段があることを確認する
      # トップページには先ほど出品した商品の配送料負担オプションがあることを確認する
    end
  end
  context '商品を出品できない時' do
    it 'ログインしていないと商品出品ページに遷移できない' do
      # トップページに遷移する
      # 商品出品ページに遷移しようとする
      # ログインページに飛ばされることを確認する
    end
  end
end
