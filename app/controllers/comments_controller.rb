class CommentsController < ApplicationController
  def create
    @item = Item.find(params[:item_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to root_path
    else
      render "items/show"
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(
      user_id: current_user.id,
      item_id: @item.id
    )
  end
end
