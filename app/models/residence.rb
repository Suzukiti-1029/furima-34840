class Residence < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :purchase_history

  belongs_to :prefecture
end
