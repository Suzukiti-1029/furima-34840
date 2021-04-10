module ItemVisibleCheckerSupport
  def item_visible_checker(item, img_file, all_request_bool)
    expect(page).to have_selector("img[src$='#{img_file}']")
    expect(page).to have_content(item.name)
    expect(page).to have_content(item.fee)
    expect(page).to have_content(item.fare_option.name)
    if all_request_bool
      expect(page).to have_content(item.describe)
      expect(page).to have_content(item.category.name)
      expect(page).to have_content(item.situation.name)
      expect(page).to have_content(item.prefecture.name)
      expect(page).to have_content(item.need_days.name)
    end
  end
end