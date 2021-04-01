class ResidencesController < ApplicationController
  def new
    @residence = Residence.new
    @item = Item.find(params[:item_id])
  end

  def create
  end
end

