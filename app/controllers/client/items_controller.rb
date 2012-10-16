class Client::ItemsController < ApplicationController
  def sub_layout
    "client/menu"
  end

  def show
    section_path, item_alias = Item.split_item_path request.path
    @section = Section.find_by_path(section_path) || not_found
    @item = Item.find_by_alias_and_section_id(item_alias, @section.id) || not_found
    not_found if @section.hidden or @item.hidden

    menu_list
    bread_crumbs
  end



  private

  def bread_crumbs
    current_menu_element = @menu_list.select {|e| @section.id == e.id}.first
    @bread_crumbs = [current_menu_element.bread_crumbs, @item.name].flatten
  end
end
