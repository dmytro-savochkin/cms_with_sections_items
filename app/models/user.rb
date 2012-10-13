class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable

  attr_accessible :provider, :uid, :name, :email, :encrypted_password


  def self.email_from_auth_data(auth, provider)
    email = ""
    email = auth.info.nickname+'@twitter.com' if provider == "twitter"
    email = auth.extra.raw_info.domain+'@vk.com' if provider == "vkontakte"
    email = auth.info.email if provider == "google_oauth2"
    email = auth.info.email if provider == "facebook"
    email
  end


  def self.find_oauth(provider, auth, signed_in_resource=nil)
    logger.info auth.inspect
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create( name:auth.info.name,
                          provider:provider,
                          uid:auth.uid,
                          email: email_from_auth_data(auth, provider),
                          encrypted_password:Devise.friendly_token[0,20]
      )
    end
    user
  end



  def self.new_with_session(params, session)
    super.tap do |user|
      data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
      if data
        user.email = data["email"] if user.email.blank?
      end
    end
  end


end
