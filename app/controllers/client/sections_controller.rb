class Client::SectionsController < ApplicationController
  def sub_layout
    "client/menu"
  end


  def index
    menu_list
    @menu_tree = Menu.list_to_hash @menu_list
    bread_crumbs
    @items_on_main_page = Item.
        where(:on_main_page => true, :hidden => false).
        order('section_id ASC, position ASC')
    @items_on_main_page.each {|item| item.parent_section_path = @menu_tree[item.section_id].full_path}
  end


  def show
    @section = Section.find_by_path(request.fullpath) || not_found

    not_found if @section.hidden
    @section_items = @section.items.each {|item| item.parent_section_path = request.fullpath}


    menu_list
    bread_crumbs
  end




  private

  def bread_crumbs
    return [] if request.fullpath == "/"
    current_menu_element = @menu_list.select {|e| request.fullpath == e.full_path}.first
    @bread_crumbs = current_menu_element.bread_crumbs
  end
end
