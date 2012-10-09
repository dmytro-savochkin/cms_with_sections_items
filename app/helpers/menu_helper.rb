module MenuHelper

  def place_list_tags_for(flattened_tree)
    tags = list_tags

    previous_level = 1
    sections_list = []
    sections_list << tags[:ul]
    last_node_type = ""

    flattened_tree.each_with_index do |node, index|
      tags[:li] = tag("li", {:class => [node.class, node[:id]]}, true)
      if node.kind_of? Section
        raise NoLevelError unless node.respond_to? :level
        current_level = node[:level]
        level_differences = (current_level - previous_level).abs

        has_children = has_children? flattened_tree, index


        sections_list << tags[:closed_ul] if last_node_type == :item

        if current_level < previous_level
          sections_list << tags[:closed_ul]
          (level_differences-1).times {sections_list << tags[:closed_li] + tags[:closed_ul]}
          sections_list << tags[:closed_li]
        end

        sections_list << tags[:li] if current_level <= previous_level

        if current_level > previous_level
          level_differences.times do
            sections_list << tags[:ul] + tags[:li]
          end
        end

        sections_list << node
        sections_list << tags[:closed_li] unless has_children


        previous_level = current_level
        last_node_type = :section
      elsif node.kind_of? Item
        sections_list << tags[:ul] if last_node_type == :section
        sections_list << tags[:li] << node << tags[:closed_li]
        last_node_type = :item
      end
    end

    (previous_level - 1).times {sections_list << tags[:closed_ul] + tags[:closed_li]} if previous_level > 1

    sections_list << tags[:closed_ul]
    sections_list
  end



  private

  def has_children?(list, index)
    if index < list.length - 1
      node = list[index]
      next_node = list[index+1]
      has_children = next_node.kind_of?(Item) || next_node[:level] > node[:level]
    else
      has_children = false
    end
    has_children
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