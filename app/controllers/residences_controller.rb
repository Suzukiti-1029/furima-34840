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
      pay_item
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
      item_id: @item.id,
      item_fee: @item.fee,
      token: params[:token]
    )
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_root
    # 履歴がある(購入されている)ならば、
    redirect_to root_path unless @item.purchase_history.nil?
    redirect_to root_path if @item.user.id == current_user.id
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: residence_params[:item_fee],
      card: residence_params[:token],
      currency: 'jpy'
    )
  end
end
