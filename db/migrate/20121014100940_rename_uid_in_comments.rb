class RenameUidInComments < ActiveRecord::Migration
  def up
    rename_column :comments, :uid, :user_id
  end

  def down
  end
end
