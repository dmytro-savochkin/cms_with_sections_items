class CreateItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string :name
      t.string :alias
      t.integer :section_id
      t.integer :position
      t.string :price
      t.string :amount
      t.string :manufacturer
      t.string :photo_thumb
      t.string :photo_full
      t.text :description
      t.boolean :on_main_page

      t.boolean :hidden
      t.timestamps
    end
  end

  def down
    drop_table :sections
  end
end
