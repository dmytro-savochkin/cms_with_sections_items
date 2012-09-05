class Admin::SectionsController < ApplicationController
  before_filter :authorized?

  def sub_layout
    "admin"
  end



  def index
    @sections = Section.order(:position)
  end

  def show
    @section = Section.find params[:id]
  end

  def edit
    @section = Section.find params[:id]
    @sections = Section.order(:position)
  end

  def update
    @section = Section.find params[:id]
    @section.update_attributes!(params[:section])
    flash[:notice] = "#{@section.title} was successfully updated."
    redirect_to section_path(@section)
  end

  def new
  end

  def create
    @section.create!(params[:section])
    flash[:notice] = "#{@section.title} was successfully created."
    redirect_to sections_path
  end

  def destroy
    @section = Section.find params[:id]
    @section.destroy
    flash[:notice] = "Section '#{@section.title}' has been deleted."
    redirect_to sections_path
  end




  protected
  def authorized?
    current_user = session[:user]
    authorized = Admin.admin? current_user
    redirect_to admin_login_path if authorized.nil?
  end



end
