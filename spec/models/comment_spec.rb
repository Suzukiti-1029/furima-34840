require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe 'コメント機能' do
    context 'コメントが保存できる時' do
      it '情報が全て正しく入力されていればコメントできる' do
        expect(@comment).to be_valid
      end
    end
    context 'コメントが保存されない時' do
      it 'textが空だとコメントできない' do
        @comment.text = ''
        @comment.valid?
        expect(@comment.errors.full_messages).to include("Text can't be blank")
      end
      it 'ログインしていないとコメントできない' do
        @comment.user = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include("User must exist")
      end
    end
  end

end
