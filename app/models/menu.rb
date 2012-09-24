class Menu < ActiveRecord::Base

  class << self
    def with_items
      menu_list = []

      items_tree = {}
      Item.order('position').each do |item|
        parent_id = item[:section_id]
        items_tree[parent_id] ||= []
        items_tree[parent_id] << item
      end

      self.without_items().each do |section|
        menu_list << section
        menu_list << items_tree[section[:id]] if not items_tree[section[:id]].nil?
      end

      menu_list.flatten
    end


    def without_items
      menu = Section.order('position').flatten
      menu
    end
  end

end
