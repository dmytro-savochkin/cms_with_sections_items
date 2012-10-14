module ClientLoginMethods
  def after_sign_in_path_for(resource_or_scope)
    logger.info request.env['omniauth.origin'].inspect
    request.env['omniauth.origin'] || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.env['HTTP_REFERER'] || root_path
  end
end