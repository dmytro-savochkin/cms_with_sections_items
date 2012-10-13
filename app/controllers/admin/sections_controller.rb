class Admin::SectionsController < ApplicationController
  include AdminLoginMethods
  respond_to :html, :js, :json

  before_filter :authenticate_admin!


  def sub_layout
    "admin/right_menu"
  end






  def index
    @menu_list = Menu.without_items
  end


  def edit
    @section = Section.find params[:id]
    @tabulated_sections = Section.tabulated_without_descendants_of(@section)
  end


  def update
    @section = Section.update_with_shift(params[:section], params[:id])

    if @section.valid?
      flash[:success] = "#{@section.name} was successfully updated."
      redirect_to admin_sections_path
    else
      flash.now[:error] = "Some errors occurred."
      @tabulated_sections = Section.tabulated_without_descendants_of(@section)
      render :edit
    end
  end


  def new
    @section = Section.new
    @tabulated_sections = Section.tabulated_sections
  end


  def create
    @section = Section.create_with_shift(params[:section])

    if @section.valid?
      flash[:success] = "#{@section.name} was successfully created."
      redirect_to admin_sections_path
    else
      flash.now[:error] = "Some errors occurred."
      @tabulated_sections = Section.tabulated_sections
      render :new
    end
  end


  def destroy
    @section = Section.find params[:id]
    if @section.destroy_with_shift
      flash[:success] = "Section '#{@section.name}' has been deleted."
    else
      flash[:error] = "Some error occurred during deletion of '#{@section.name}'."
    end
    redirect_to admin_sections_path
  end




  def shift
    @section = Section.find params[:id]
    next_section = @section.shift(params[:direction])
    if next_section
      respond_to do |format|
        format.html { redirect_to admin_sections_path }
        format.json do
          sections_to_swap = [@section[:id], next_section[:id]]
          sections_to_swap.reverse! if params[:direction] == "up"
          return_data = {:type => @section.class.to_s, :elements => sections_to_swap}
          render :json => return_data.to_json
        end
      end
    else
      flash[:error] = "Section '#{@section[:name]}' can not be shifted #{params[:direction]}."
      redirect_to admin_sections_path
    end
  end

end
