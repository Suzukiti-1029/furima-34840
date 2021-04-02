class ResidencePurchaseHistory
  include ActiveModel::Model
  attr_accessor :area_number, :prefecture_id,
    :city, :address, :building, :phone_number,
    :user_id, :item_id
end