class AddDescriptionToSections < ActiveRecord::Migration
  def up
    add_column :sections, :description, :text
  end

  def down
    remove_column :sections, :description, :text
  end
end
