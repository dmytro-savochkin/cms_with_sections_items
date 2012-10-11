class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    admin_sections_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path
  end
end
