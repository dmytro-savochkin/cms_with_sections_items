class Client::CommentsController < ApplicationController
  before_filter :authenticate_user!


  def create
    @comment = Comment.new(
      text:params[:comment][:text],
      visible:true,
      item_id:params[:comment][:item_id],
      user_id:current_user.id,
      provider:current_user.provider,
      name:current_user.name
    )

    if @comment.save
      flash[:success] = "Comment was successfully created."
    else
      flash[:error] = "Comment cannot be created. Please check your text message."
    end

    redirect_to request.env["HTTP_REFERER"]
  end


end
