module ApplicationHelper
  def link_color?(hidden)
    return "muted" if hidden
    ""
  end

end
