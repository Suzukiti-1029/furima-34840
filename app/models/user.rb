class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :purchase_histories
  has_many :comments

  with_options presence: true do
    validates :nickname
    validates :birthday
  end

  PASSWORD_RULE = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/.freeze
  validates_format_of :password, with: PASSWORD_RULE, message: 'には英字と数字の両方を含めて設定してください'

  with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: '全角文字を使用してください' } do
    validates :last_name
    validates :first_name
  end
  with_options presence: true, format: { with: /\A[ァ-ヶー]+\z/, message: '全角カタカナを使用してください' } do
    validates :last_name_detail
    validates :first_name_detail
  end
end
