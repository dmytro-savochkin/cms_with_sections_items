module Client::RoutingHelper
  def item_path(item)
    "/item/" + item.alias
  end

  def link_to_nth_element_of(n, path)
    "/" + path.split("/").drop(1)[0..n].join("/")
  end
end
