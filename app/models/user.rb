class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true

  PASSWORD_RULE = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/.freeze
  validates_format_of :password, with: PASSWORD_RULE, message: 'には英字と数字の両方を含めて設定してください'

  with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: '全角文字を使用してください' } do
    validates :last_name
    validates :first_name
  end
  with_options format: { with: /\A[ァ-ヶー]+\z/, message: '全角カタカナを使用してください' } do
    validates :last_name_detail
    validates :first_name_detail
  end
  validates :birthday, presence: true
end
