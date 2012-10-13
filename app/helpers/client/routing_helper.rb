module Client::RoutingHelper
  def item_path(item)
    "/item/" + item.alias
  end

  def link_to_nth_element_of(n, path)
    return "/" if n == 0
    "/" + path.split("/").drop(1)[0...n].join("/")
  end

  def add_root_element_to_bread_crumbs(root_element)
    unless @bread_crumbs.nil?
      @bread_crumbs.unshift root_element
    end
  end
end
