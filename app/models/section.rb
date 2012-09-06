class Section < ActiveRecord::Base
  attr_accessible :name, :level, :short_name, :alias, :parent_id, :hidden, :description

  validates :alias, :length => { :in => 1..40 }, :format => {:with => /[0-9a-z_]+/}
  validates :name, :length => { :in => 1..120 }
  validates :short_name, :length => { :in => 1..40 }
  validates :description, :length => { :in => 1..1200 }
  validates_presence_of :name, :short_name, :alias, :position, :description

  # TODO: add checking of uniqueness of (level + _branch_ + alias +  )
  # TODO: расставить звездочки в виде в зависимости от наличия правила заполнения



  class << self

    def all_flattened(sections = self.order(:position), ul = "<ul>".html_safe, li = "<li>".html_safe)
      flattened_tree = sections.flatten

      closed_ul = ul.clone.insert(1, "/").html_safe
      closed_li = li.clone.insert(1, "/").html_safe
      last_level = 1
      sections_tree = []

      sections_tree << ul
      flattened_tree.each do |node|
        raise NoLevelError unless node.respond_to? :level

        current_level = node[:level]
        level_differences = (current_level - last_level).abs

        if current_level < last_level
          sections_tree << closed_ul
          (level_differences-1).times {sections_tree << closed_li+closed_ul}
          sections_tree << closed_li
        end

        sections_tree << li

        level_differences.times {sections_tree << ul+li} if current_level > last_level

        siblings = Section.where(:level => current_level, :parent_id => node[:parent_id])
        node[:shifts] = {}
        node[:shifts][:up] = (siblings.where("position < ?", node[:position]).count > 0)
        node[:shifts][:down] = (siblings.where("position > ?", node[:position]).count > 0)


        sections_tree << node
        sections_tree << closed_li
        last_level = current_level
      end
      sections_tree << closed_ul
    end


    def tabulated_sections(sections = self.order(:position), tab = "&nbsp;")
      sections.map! { |e| [(tab * 2 * e[:level] + e.name).html_safe, e[:id]] }
    end


    def tabulated_without_descendants_of(section)
      all_sections = self.order(:position)
      sections_without_descendants = all_sections - section.descendants
      tabulated_sections(sections_without_descendants)
    end





    def update_with_shift(attributes, id)
      section = Section.find id

      old_parent_id = section[:parent_id]
      old_position = section[:position]
      old_level = section[:level]
      descendants = section.descendants
      descendants_ids = descendants.map(&:id)

      section.attributes = attributes

      if section.valid?
        section.save

        if old_parent_id.to_i != attributes[:parent_id].to_i

          if section[:parent_id].nil?
            new_level = 1
            new_position = Section.maximum('position').to_i + 1 - descendants.length
          else
            new_parent = Section.find_by_id(section[:parent_id])
            new_level = new_parent[:level] + 1
            new_position = new_parent[:position] + 1
            new_position -= descendants.length if new_parent[:position] > old_position
          end

          # сдвигаем все последующие назад
          Section.
              where('position >= ? AND id NOT IN (?)', old_position, descendants_ids).
              update_all(["position = position - ?", descendants.length.to_s])

          # освобождаем место для переставляемой ветки
          Section.
              where('position >= ? AND id NOT IN (?)', new_position, descendants_ids).
              update_all(["position = position + ?", descendants.length])

          # вставляем ветку и меняем номера и левелы у себя и потомков
          position_difference = new_position - old_position
          level_difference = new_level - old_level
          Section.where('id IN (?)', descendants_ids).update_all(["position = position + ?", position_difference])
          Section.where('id IN (?)', descendants_ids).update_all(["level = level + ?", level_difference])
        end
      end

      section
    end



    def create_with_shift(attributes)
      section = Section.new
      section.attributes = attributes

      if section[:parent_id].nil?
        section[:level] = 1
        section[:position] = Section.maximum('position').to_i + 1
        must_shift = false
      else
        parent_section = Section.find_by_id(section[:parent_id])
        section[:level] = parent_section[:level] + 1
        section[:position] = parent_section[:position] + 1
        must_shift = true
      end

      if section.save and must_shift
        Section.where('position >= ? AND id <> ?', section[:position], section[:id]).update_all("position = position + 1")
      end

      section
    end


    #noinspection RubyArgCount
    def shift(id, direction)
      case direction
        when "up"
          directional = {:condition => "<", :ordering => "DESC", :next => "-1"}
        when "down"
          directional = {:condition => ">", :ordering => "ASC", :next => "+1"}
        else
          raise WrongDirectionError
      end

      section = Section.find id
      next_section = Hash
      if section.can_be_shifted? directional[:condition]
        next_section = Section.
            where(:level => section[:level], :parent_id => section[:parent_id]).
            where("position #{directional[:condition]} ?", section[:position]).
            order("position #{directional[:ordering]}").
            first

        Section.
            where('id IN (?)', section.descendants.map(&:id)).
            update_all(["position = position + ?", directional[:next].to_i * next_section.descendants.length])

        Section.
            where('id IN (?)', next_section.descendants.map(&:id)).
            update_all(["position = position + ?", -1 * directional[:next].to_i * section.descendants.length])
      end

      section
    end

  end






  def can_be_shifted?(condition)
    Section.
        where(:level => self[:level], :parent_id => self[:parent_id]).
        where("position #{condition} ?", self[:position]).count > 0
  end





  def destroy_with_shift
    if self.destroy
      Section.where('position >= ?', self[:position]).update_all("position = position - 1")
    else
      false
    end
  end






  def descendants
    descendants = [self]

    lowest_sections = Section.where("level > ?", self[:level]).order(:level)
    lowest_sections.each do |section|
      descendants << section if section.descendant_of?(descendants)
    end

    descendants
  end

  def descendant_of?(sections)
    sections.each do |section|
      return true if self[:parent_id] == section[:id]
    end
    false
  end



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
