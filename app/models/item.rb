class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :user
  belongs_to :category, :situation, :fare_option, :prefecture, :need_days
  has_one_attached :image

  with_options presence: true do
    validates :image
    validates :name
    validates :describe
  end

  with_options numericality: {other_than: 1} do
    validates :category_id
    validates :situation_id
    validates :fare_option_id
    validates :prefecture_id
    validates :need_days_id
  end

  validates :fee, presence: true, numericality: {only_integer: true , greater_than: 300, less_than: 9999999}
end
