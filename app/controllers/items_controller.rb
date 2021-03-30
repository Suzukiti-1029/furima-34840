class ItemsController < ApplicationController
  def index
  end
  def new
    @item = Item.new
  end
  def create
    @item = Item.new(item_params)
    binding.pry
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def item_params
    params.require(:item).permit(
      :image, :name, :describe, :category_id, :situation_id, :fare_option_id, :prefecture_id, :need_days_id, :fee
    ).merge(
      user_id: current_user.id
    )
  end
end