module SetDataSupport
  def set_data(user, item, all_data_bool)
    if all_data_bool
      user = FactoryBot.create(:user)
      item = FactoryBot.create(:item)
    end
    residence_purchase_history = FactoryBot.build(
      :residence_purchase_history,
      user_id: user.id,
      item_id: item.id,
      item_fee: item.fee
    )
    residence_purchase_history.save
    sleep 0.1
  end
end
