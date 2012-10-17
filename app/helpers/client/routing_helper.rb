module Client::RoutingHelper
  def link_to_nth_element_of(n, path)
    return root_path if n == 0
    section_path path.split("/").drop(1)[0...n].join("/")
  end

  def add_root_element_to_bread_crumbs
    unless @bread_crumbs.nil?
      @bread_crumbs.unshift({
        :name => t('layouts.client.bread_crumbs.home'),
        :name_ru => t('layouts.client.bread_crumbs.home')
      })
    end
  end


  def current_path_for(lang)
    path = request.fullpath
    if path.include? 'locale='
      path = request.fullpath.gsub(/locale=../, "locale=#{lang}")
    else
      add_string = "?locale=#{lang}"
      add_string.slice![1..-1] if path.include? '?'
      path + add_string
    end
  end
end
