class AddPositionFieldInCommentsTable < ActiveRecord::Migration
  def up
    add_column :comments, :position, :integer
  end

  def down
    remove_column :comments, :position
  end
end
