class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :move_to_root, only: [:edit, :update, :destroy]

  def index
    @items = Item.all.order('created_at DESC')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(
      :image, :name, :describe, :category_id, :situation_id, :fare_option_id, :prefecture_id, :need_days_id, :fee
    ).merge(
      user_id: current_user.id
    )
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_root
    redirect_to root_path if @item.user.id != current_user.id
  end

end
