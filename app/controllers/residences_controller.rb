class ResidencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :move_to_root
  def new
    @residence_purchase_history = ResidencePurchaseHistory.new
  end

  def create
    @residence_purchase_history = ResidencePurchaseHistory.new(residence_params)
    if @residence_purchase_history.valid?
      @residence_purchase_history.save
    else
      render :new
    end
  end

  private
  def residence_params
    params.require(:residence_purchase_history).permit(
      :area_number, :prefecture_id, :city, :address, :building, :phone_number
    ).merge(
      user_id: current_user.id,
      item_id: @item.id
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_root
    redirect_to root_path if @item.user.id == current_user.id
  end
end

