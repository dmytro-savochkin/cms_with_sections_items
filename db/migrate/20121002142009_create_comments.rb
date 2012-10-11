class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user
      t.string :text
      t.boolean :visible
      t.timestamps
    end
  end
end
