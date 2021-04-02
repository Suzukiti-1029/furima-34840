class ResidencePurchaseHistory
  include ActiveModel::Model
  attr_accessor :area_number, :prefecture_id,
    :city, :address, :building, :phone_number,
    :user_id, :item_id

  with_options presence: true do
    validates :area_number, format: {
        with: /\A\d{3}[-]\d{4}\z/,
        message: '3ケタの半角数字、半角ハイフン(-)、4ケタの半角数字を続けて入力してください'
      }
    validates :city
    validates :address
    validates :phone_number, format: {
        with: /\A\d{10,11}\z/,
        message: '10ケタか11ケタの半角数字を続けて入力してください'
      }
    validates :user_id
    validates :item_id
  end

  validates :prefecture_id, numericality: { other_than: 1 }
end