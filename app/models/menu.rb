class Menu < ActiveRecord::Base

  class << self
    def with_items
      items_tree = form_items_tree
      menu_list = form_sections_list_with items_tree
      menu_list.flatten
    end

    def without_items
      sections = Section.order('position')
      add_shift_fields_for_sections(sections).flatten
    end











    private

    def form_items_tree
      items_tree = {}
      Item.order('position').each do |item|
        parent_id = item[:section_id]
        items_tree[parent_id] ||= []
        items_tree[parent_id] << item
      end

      add_shift_fields_for_items(items_tree)

      items_tree
    end

    def form_sections_list_with(items_tree)
      menu_list = []
      self.without_items().each do |section|
        menu_list << section
        menu_list << items_tree[section[:id]] if not items_tree[section[:id]].nil?
      end
      menu_list
    end





    def add_shift_fields_for_items(items_tree)
      items_tree.each do |parent, items|
        items_count = items.count
        items.each_with_index do |item, i|
          item.can_be_shifted = {:down => false, :up => false}
          item.can_be_shifted[:up] = true if i > 0
          item.can_be_shifted[:down] = true if i < items_count - 1
        end
      end
    end

    def add_shift_fields_for_sections(sections_list)
      current_level = 0
      stack = ["root"]
      tree = []
      sections_list.each do |element|
        if current_level == element[:level]
          stack.pop
        elsif current_level > element[:level]
          (current_level - element[:level] + 1).times { stack.pop }
        end
        stack.push element[:id]

        current_level = element[:level]
        tree.push stack.clone
      end

      sections_list.each_with_index do |menu_element, i|
        level = menu_element[:level]
        parent = tree[i][-2]
        menu_element.can_be_shifted = {:up => false, :down => false}
        menu_element.can_be_shifted[:up] = true if siblings_exist?(tree[0...i], level, parent)
        menu_element.can_be_shifted[:down] = true if siblings_exist?(tree[(i+1)...tree.length], level, parent)
      end

      sections_list
    end

    def siblings_exist?(array, level, parent)
      array.each do |element|
        return true if (element.length - 1) == level and element[level-1] == parent
      end
      false
    end
  end

end
