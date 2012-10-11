class AddItemFieldInCommentsTable < ActiveRecord::Migration
  def up
    add_column :comments, :item_id, :integer
  end

  def down
    remove_column :comments, :item_id
  end
end
