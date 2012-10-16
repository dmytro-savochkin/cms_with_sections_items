class Menu < ActiveRecord::Base

  class << self
    def with_items
      items_tree = form_items_tree
      menu_list = form_sections_list_with items_tree
      menu_list.flatten
    end

    def without_items
      sections = Section.order('position')
      menu_list = add_shift_fields_for_sections sections
      menu_list.flatten
    end

    def list_to_hash(list)
      hash = {}
      list.each { |element| hash[element.id] = element}
      hash
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

    def add_shift_fields_for_sections(menu_list)
      current_level = 0
      stack = [{:id => 'root', :alias => nil, :name => nil}]
      tree = []
      menu_list.each do |menu_element|
        if current_level == menu_element[:level]
          stack.pop
        elsif current_level > menu_element[:level]
          (current_level - menu_element[:level] + 1).times { stack.pop }
        end
        stack.push menu_element

        current_level = menu_element[:level]
        tree.push stack.clone
      end

      menu_list.each_with_index do |menu_element, index|
        level = menu_element[:level]
        parent = tree[index][-2][:id]
        menu_element.can_be_shifted = {:up => false, :down => false}
        menu_element.can_be_shifted[:up] = true if siblings_exist?(tree[0...index], level, parent)
        menu_element.can_be_shifted[:down] = true if siblings_exist?(tree[(index+1)...tree.length], level, parent)
        menu_element.full_path = tree[index].drop(1).map{|e|e[:alias]}.join('/')
        menu_element.bread_crumbs = tree[index].drop(1).map{|e|e[:name]}
      end

      menu_list
    end

    def siblings_exist?(array, level, parent)
      array.each do |element|
        return true if (element.length - 1) == level and element[level-1][:id] == parent
      end
      false
    end
  end

end
