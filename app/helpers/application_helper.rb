module ApplicationHelper
  def html_tag(tag_name, close = false)
    tag = tag(tag_name, nil, true)
    tag.insert(1, "/") if close
    tag
  end

  def flatten_as_lists(sections, list_tag = "ul", line_tag = "li")
    flattened_tree = sections.flatten

    ul = html_tag(list_tag)
    closed_ul = html_tag(list_tag, true)
    li = html_tag(line_tag)
    closed_li = html_tag(line_tag, true)

    last_level = 1
    sections_tree = []

    sections_tree << ul
    flattened_tree.each do |node|
      raise NoLevelError unless node.respond_to? :level

      current_level = node[:level]
      level_differences = (current_level - last_level).abs

      if current_level < last_level
        sections_tree << closed_ul
        (level_differences-1).times {sections_tree << closed_li+closed_ul}
        sections_tree << closed_li
      end

      sections_tree << li

      level_differences.times {sections_tree << ul+li} if current_level > last_level

      sections_tree << node
      sections_tree << closed_li
      last_level = current_level
    end
    sections_tree << closed_ul
  end


  def section_checkbox_tree(sections)

    sections.
        delete_if {|elem| elem == @section || elem.ancestors.include?(@section) }.
        map! do |e|
          {
            :name => "&nbsp;" * 2 * e[:level] + e.name,
            :id => e[:id]
          }
        end
  end

end
