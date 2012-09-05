class Admin < ActiveRecord::Base
  class << self
    def hash_password(password)
      Digest::MD5.hexdigest(password)
    end

    def admin?(user)
      return nil if user.nil?
      self.where(user)
    end
  end

  attr_accessible :name, :password_hash
end
