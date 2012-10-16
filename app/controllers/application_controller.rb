class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  rescue_from ActionController::RoutingError, :with => :render_404



  def module_name
    class_name = self.class.name
    if class_name.index("::").nil?
      module_name = nil
    else
      module_name = class_name.split("::").first
    end
    module_name
  end


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end





  protected

  def menu_list
    @menu_list = Menu.without_items
  end

  def set_locale
    I18n.locale = params[:locale]
  end

  def default_url_options(options = {})
    logger.debug options.inspect
    if I18n.locale != I18n.default_locale
      return { :locale => I18n.locale }
    end
    {}
  end





  private

  def render_404(exception = nil)
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
