class CommentsController < ApplicationController
  def create
    @item = Item.find(params[:item_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      ActionCable.server.broadcast 'comment_channel', content: [@comment, @comment.user, @item.comments.all.length]
    else
      @comments = @item.comments.includes(:user)
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
