module SetItemEmptyDataSupport
  def set_item_empty_data(item)
    item.name = ''
    item.describe = ''
    item.category_id = 1
    item.situation_id = 1
    item.fare_option_id = 1
    item.prefecture_id = 1
    item.need_days_id = 1
    item.fee = ''
  end
end
