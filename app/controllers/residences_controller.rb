class ResidencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :move_to_root
  def new
    @residence = Residence.new
  end

  def create
    @residence = Residence.new(residence_params)
    if @residence.save
      redirect_to item_path(@item)
    else
      render :new
    end
  end

  private
  def residence_params
    params.require(:residence).permit(
      :area_number, :prefecture_id, :city, :address, :building, :phone_number
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_root
    redirect_to root_path if @item.user.id == current_user.id
  end
end

