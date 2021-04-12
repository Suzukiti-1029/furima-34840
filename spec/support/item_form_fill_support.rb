module ItemFormFillSupport
  def item_form_fill(item)
    fill_in 'item[name]', with: item.name
    fill_in 'item[describe]', with: item.describe
    select item.category.name, from: 'item[category_id]'
    select item.situation.name, from: 'item[situation_id]'
    select item.fare_option.name, from: 'item[fare_option_id]'
    select item.prefecture.name, from: 'item[prefecture_id]'
    select item.need_days.name, from: 'item[need_days_id]'
    fill_in 'item[fee]', with: item.fee
  end
end
