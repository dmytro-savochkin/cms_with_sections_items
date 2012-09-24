module MenuHelper

  def place_list_tags(flattened_tree)
    tags = list_tags

    last_level = 1
    sections_tree = []

    sections_tree << tags[:ul]
    last_node_type = ""
    p flattened_tree.inspect
    flattened_tree.each do |node|

      siblings = Section.where(:level => node[:level], :parent_id => node[:parent_id]) if node.kind_of? Section
      siblings = Item.where(:section_id => node[:section_id]) if node.kind_of? Item
      node[:shifts] = {}
      node[:shifts][:up] = (siblings.where("position < ?", node[:position]).count > 0)
      node[:shifts][:down] = (siblings.where("position > ?", node[:position]).count > 0)


      if node.kind_of? Section
        raise NoLevelError unless node.respond_to? :level

        sections_tree << tags[:closed_ul] << tags[:closed_li] if last_node_type == :item

        current_level = node[:level]
        level_differences = (current_level - last_level).abs

        if current_level < last_level
          sections_tree << tags[:closed_ul]
          (level_differences-1).times {sections_tree << tags[:closed_li] + tags[:closed_ul]}
          sections_tree << tags[:closed_li]
        end

        sections_tree << tags[:li]

        if current_level > last_level
          level_differences.times do
            sections_tree << tags[:ul] + tags[:li]
          end
        end

        sections_tree << node
        sections_tree << tags[:closed_li]
        last_level = current_level
        last_node_type = :section
      elsif node.kind_of? Item
        sections_tree << tags[:li] << tags[:ul] if last_node_type == :section
        sections_tree << tags[:li] << node << tags[:closed_li]
        last_node_type = :item
      end
    end

    sections_tree << tags[:closed_ul]
    sections_tree
  end




  def list_tags
    tags = {}
    tags[:ul] = "<ul>".html_safe
    tags[:li] = "<li>".html_safe
    tags[:closed_ul] = tags[:ul].clone.insert(1, "/").html_safe
    tags[:closed_li] = tags[:li].clone.insert(1, "/").html_safe
    tags
  end
end