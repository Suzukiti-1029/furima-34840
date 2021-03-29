class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to [:category, :situation, :fare_option, :prefecture, :need_days]
end