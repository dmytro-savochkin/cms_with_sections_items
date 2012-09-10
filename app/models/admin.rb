class Admin < ActiveRecord::Base

  class << self

    def hash_password(password)
      Digest::MD5.hexdigest(password)
    end

  end

  attr_accessible :name, :password_hash
end
