class AddAdmin < ActiveRecord::Migration
  def up
    user = {
      :name => '123',
      :password_hash => Digest::MD5.hexdigest('456')
    }
    Admin.create! user
  end

  def down
    admin = Admin.find_by_name '123'
    admin.delete!
  end
end
