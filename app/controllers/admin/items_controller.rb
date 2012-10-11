class Admin::ItemsController < ApplicationController
  before_filter :authenticate_admin!

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
    next_item = @item.shift(params[:direction])
    if next_item
      respond_to do |format|
        format.html { redirect_to admin_items_path }
        format.json do
          items_to_swap = [@item[:id], next_item[:id]]
          items_to_swap.reverse! if params[:direction] == "up"
          return_data = {:type => @item.class.to_s, :elements => items_to_swap}
          render :json => return_data.to_json
        end
      end
    else
      flash[:error] = "Item '#{@item[:name]}' can not be shifted #{params[:direction]}."
      redirect_to admin_items_path
    end
  end

end
