class CreateSections < ActiveRecord::Migration
  def up
    create_table :sections do |t|
      t.string :name
      t.string :short_name
      t.string :alias
      t.integer :level
      t.integer :parent_id
      t.integer :position
      t.boolean :hidden
      t.timestamps
    end
  end

  def down
    drop_table :sections
  end
end
