class Residence < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  has_one :purchase_history

  belongs_to :prefecture
end
