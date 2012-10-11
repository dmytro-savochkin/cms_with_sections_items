class Admin::CommentsController < ApplicationController
  before_filter :authenticate_admin!


  def sub_layout
    "admin/right_menu"
  end



  def index
    @comments = Comment.order :created_at
  end


  def destroy
    @comment = Comment.find params[:id]
    item = @comment.item
    respond_to do |format|
      if @comment.destroy
        message = @comment.user.humanize + "'s comment has been deleted."
        flash_argument = :success
        deleted = true
      else
        message = "Some error occurred during deletion of #{@comment.user}'s comment."
        flash_argument = :error
        deleted = false
      end

      format.html do
        flash[flash_argument] = message
        redirect_to edit_admin_item_path(item)
      end
      format.json { render :json => {:message => message, :deleted => deleted}.to_json }
    end
  end


end
