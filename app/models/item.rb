class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  has_one :history

  belongs_to :category
  belongs_to :situation
  belongs_to :fare_option
  belongs_to :prefecture
  belongs_to :need_days

  has_one_attached :image

  with_options presence: true do
    validates :image
    validates :name
    validates :describe
  end

  with_options numericality: { other_than: 1 } do
    validates :category_id
    validates :situation_id
    validates :fare_option_id
    validates :prefecture_id
    validates :need_days_id
  end

  validates :fee, presence: true, numericality: {
    only_integer: true, greater_than_or_equal_to: 300,
    less_than_or_equal_to: 9_999_999
  }
end
