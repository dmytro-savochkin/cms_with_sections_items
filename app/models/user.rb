class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body




end
