class AddNewSections < ActiveRecord::Migration
  def up
    sections = [
        {:name => '1', :level => 1},
        {:name => '1', :level => 1},
        {:name => '2', :level => 2},
        {:name => '2', :level => 2},
        {:name => '3', :level => 3},
        {:name => '4', :level => 4},
        {:name => '2', :level => 2},
        {:name => '1', :level => 1},
        {:name => '2', :level => 2}
    ]
    sections.each {|section| Section.create!(section)}
  end


end
