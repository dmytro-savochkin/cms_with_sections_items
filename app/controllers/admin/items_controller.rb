class Admin::ItemsController < ApplicationController
  before_filter :authorized?

  def sub_layout
    "admin/right_menu"
  end





  protected
    def authorized?
      current_user = session[:user]
      authorized = Admin.where current_user unless current_user.nil?
      redirect_to admin_login_path if authorized.nil?
    end
end
