class Admin::CommentsController < ApplicationController
  before_filter :authenticate_admin!


  def sub_layout
    "admin/right_menu"
  end



  def index
    @comments = Comment.order(:created_at).page params[:page]
  end


  def destroy
    @comment = Comment.find params[:id]
    item_id = @comment.item.id
    respond_to do |format|
      user_name = @comment.user.name.humanize
      if @comment.destroy
        message = t 'controllers.admin.comments.delete.success', :user => user_name
        flash_argument = :success
        deleted = true
      else
        message = t 'controllers.admin.comments.delete.error', :user => user_name
        flash_argument = :error
        deleted = false
      end

      format.html do
        flash[flash_argument] = message
        redirect_to edit_admin_item_path(item_id)
      end
      format.json { render :json => {:message => message, :deleted => deleted}.to_json }
    end
  end


end
