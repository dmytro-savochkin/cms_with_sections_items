class Section < ActiveRecord::Base
  attr_accessible :name, :level

  def ancestors
    ancestors = [self]

    return ancestors if self.level == 1

    (self.level-1).downto(1) do |lvl|
      sections = Section.where(:level => lvl)
      sections.each do |section|
        ancestors << section if section.ancestor_of?(ancestors)
      end
    end

    ancestors
  end

  def ancestor_of?(sections)
    sections.each do |section|
      return true if self[:id] == section[:parent_id]
    end
    false
  end
end
