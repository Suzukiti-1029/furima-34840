class Residence < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :history

  belongs_to :prefecture
end
