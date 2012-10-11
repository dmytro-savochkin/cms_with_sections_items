class AddIndexInSection < ActiveRecord::Migration
  def up
    add_index :sections, [:alias, :parent_id], :unique => true
  end

  def down
    remove_index :sections, :name => [:alias, :parent_id]
  end
end
