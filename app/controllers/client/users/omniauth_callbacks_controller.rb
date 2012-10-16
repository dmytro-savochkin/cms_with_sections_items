class Client::Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include ClientLoginMethods


  def callback_method(provider)
    @user = User.find_oauth(provider, request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:success] = t 'controllers.client.omniath_callbacks.login_success', :user => @user.name
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise."+provider+"_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end



  def twitter
    callback_method("twitter")
  end

  def vkontakte
    callback_method("vkontakte")
  end


  def google_oauth2
    callback_method("google_oauth2")
  end

  def facebook
    callback_method("facebook")
  end





  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end