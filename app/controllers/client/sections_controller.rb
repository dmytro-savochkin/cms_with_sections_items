class Client::SectionsController < ApplicationController
  def sub_layout
    "client/menu"
  end


  def index
    menu_list
    @menu_tree = Menu.list_to_hash @menu_list
    bread_crumbs(true)
    @items_on_main_page = Item.
        where(:on_main_page => true, :hidden => false).
        order('section_id ASC, position ASC').
        page params[:page]

    @items_on_main_page.each {|item| item.parent_section_path = @menu_tree[item.section_id].full_path}
  end


  def show
    @section = Section.find_by_path(request.path) || not_found
    not_found if @section.hidden

    logger.info request.path
    logger.info request.path
    logger.info request.path
    logger.info request.path
    logger.info request.path
    logger.info request.path

    @section_items = @section.items.each {|item| item.parent_section_path = request.path[1..-1]}

    menu_list
    bread_crumbs
  end




  private

  def bread_crumbs(root = false)
    if root
      @bread_crumbs = []
      return
    end

    current_menu_element = @menu_list.select {|e| request.path == '/' + e.full_path}.first
    @bread_crumbs = current_menu_element.bread_crumbs
  end
end
