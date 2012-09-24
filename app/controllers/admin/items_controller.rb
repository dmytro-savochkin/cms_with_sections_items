class Admin::ItemsController < ApplicationController
  before_filter :authorized?

  def sub_layout
    "admin/right_menu"
  end


  def index
    @menu_list = Menu.with_items
  end




  def edit
    @item = Item.find params[:id]
    @tabulated_sections = Section.tabulated_sections
  end


  def update
    @item = Item.find params[:id]
    @item.update_and_shift params[:item]

    if @item.valid?
      flash[:success] = "#{@item[:name]} was successfully updated."
      redirect_to admin_items_path
    else
      flash.now[:error] = "Some errors occurred."
      @tabulated_sections = Section.tabulated_sections
      render :edit
    end
  end


  def new
    @item = Item.new
    @tabulated_sections = Section.tabulated_sections
  end


  def create
    @item = Item.create(params[:item])

    if @item.save
      flash[:success] = "#{@item[:name]} was successfully created."
      redirect_to admin_items_path
    else
      flash.now[:error] = "Some errors occurred."
      @tabulated_sections = Section.tabulated_sections
      render :new
    end
  end


  def destroy
    @item = Item.find params[:id]

    if @item.destroy
      flash[:success] = "Item '#{@item.name}' has been deleted."
    else
      flash[:error] = "Some error occurred during deletion of '#{@item.name}'."
    end
    redirect_to admin_items_path
  end




  def shift
    @item = Item.find params[:id]
    if @item.shift(params[:direction])
      flash[:success] = "Item '#{@item[:name]}' has been shifted #{params[:direction]}."
    else
      flash[:error] = "Item '#{@item[:name]}' can not be shifted #{params[:direction]}."
    end
    redirect_to admin_items_path
  end











  protected

  def authorized?
    current_user = session[:user]
    authorized = Admin.where current_user unless current_user.nil?
    redirect_to admin_login_path if authorized.nil?
  end
end
