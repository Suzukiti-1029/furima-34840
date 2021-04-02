class History < ApplicationRecord
  belongs_to :user
  belongs_to :item
  belongs_to :residence
end
