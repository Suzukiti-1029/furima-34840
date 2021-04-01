class ResidencesController < ApplicationController
  def new
    @residence = Residence.new
    @item = Item.find(params[:item_id])
  end

  def create
    @residence = Residence.new(residence_params)
    @item = Item.find(params[:item_id])
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
end

