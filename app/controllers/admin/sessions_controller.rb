class Admin::SessionsController < ApplicationController
  def sub_layout
    "admin"
  end


  def new
  end

  def create
    login_data = params[:session]
    login_data[:password_hash] = Admin.hash_password(login_data[:password])
    found = Admin.where(
      :name => login_data[:name],
      :password_hash => login_data[:password_hash]
    ).empty?
    if found
      flash[:error] = "Wrong login or password."
      redirect_to admin_login_path
    else
      session[:user] = {
          :name => login_data[:name],
          :password_hash => Admin.hash_password(login_data[:password])
      }
      redirect_to admin_sections_path
    end
  end


  def destroy
    session[:user] = nil
    flash[:success] = "You have logged out."
    redirect_to admin_login_path
  end
end
