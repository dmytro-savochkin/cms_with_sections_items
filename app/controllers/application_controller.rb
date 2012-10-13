class ApplicationController < ActionController::Base
  protect_from_forgery

  #rescue_from ActionController::RoutingError, :with => :render_404



  def after_sign_in_path_for(resource_or_scope)
    admin_sections_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end


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
    logger.info "LOGLOGLOGLOGLOGLOGLOGLOGLOG1"
    raise ActionController::RoutingError.new('Not Found')
  end





  protected

  def menu_list
    @menu_list = Menu.without_items
  end





  private

  def render_404(exception = nil)
    logger.info "LOGLOGLOGLOGLOGLOGLOGLOGLOG2"
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
