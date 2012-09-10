class Admin::SectionsController < ApplicationController
  before_filter :authorized?

  def sub_layout
    "admin/right_menu"
  end






  def index
    @flattened_sections = Section.all_flattened
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
    if @section.shift(params[:direction])
      flash[:success] = "Section '#{@section[:name]}' has been shifted #{params[:direction]}."
    else
      flash[:error] = "Section '#{@section[:name]}' can not be shifted #{params[:direction]}."
    end
    redirect_to admin_sections_path
  end











  protected
    def authorized?
      current_user = session[:user]
      authorized = Admin.where current_user unless current_user.nil?
      redirect_to admin_login_path if authorized.nil?
    end



end
