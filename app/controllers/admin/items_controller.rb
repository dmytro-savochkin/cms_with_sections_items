class Admin::ItemsController < ApplicationController
  before_filter :authorized?

  def sub_layout
    "admin"
  end





  protected
  def authorized?
    current_user = session[:user]
    authorized = Admin.admin? current_user
    redirect_to admin_login_path if authorized.nil?
  end
end
