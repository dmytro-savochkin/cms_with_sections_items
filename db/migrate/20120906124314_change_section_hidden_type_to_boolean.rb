class ChangeSectionHiddenTypeToBoolean < ActiveRecord::Migration
  def up
    change_table :sections do |t|
      t.change :hidden, :boolean
    end
  end

  def down
  end
end
