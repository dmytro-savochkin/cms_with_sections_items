class Item < ActiveRecord::Base
  belongs_to :section
  has_many :comments, :foreign_key => 'item_id', :order => 'created_at', :dependent => :delete_all


  paginates_per 9


  before_validation :set_position_if_not_set
  before_destroy :move_back_next_items


  attr_accessible :name, :alias, :section_id, :amount, :manufacturer,
                  :photo, :description, :on_main_page, :name_ru,
                  :hidden, :position, :price, :id, :created_at, :updated_at

  attr_accessor :can_be_shifted, :full_path, :bread_crumbs, :parent_section_path

  has_attached_file :photo, :styles => { :thumb => "200x200>" },
                    :path => ':rails_root/public/uploads/:class/:attachment/:style/photo_:id.:extension',
                    :url => '/uploads/:class/:attachment/:style/photo_:id.:extension',
                    :default_url => "/images/default_item_photo.png"
  validates_attachment :photo,
                       :size => { :in => 0..500.kilobytes }
  validates_attachment_content_type :photo,
                                    :content_type => %w(image/jpeg image/png image/gif),
                                    :message => I18n.t('models.item.wrong_photo_content_type')


  validates_format_of :alias, :with => /^[0-9a-z_-]+$/, :message => I18n.t('models.item.wrong_alias')
  validates_length_of :alias, :in => 1..40
  validates_length_of :name, :in => 1..120
  validates_length_of :manufacturer, :maximum => 120
  validates_length_of :amount, :maximum => 120
  validates_length_of :description, :maximum => 1200
  validates_presence_of :name, :alias, :position, :price, :section_id
  validates_uniqueness_of :alias, :scope => :section_id, :message => I18n.t('models.item.wrong_alias_uniqueness')




  class << self
    def shifting_array(direction)
      case direction
        when "up"
          directional = {:condition => "<", :ordering => "DESC", :next => -1}
        when "down"
          directional = {:condition => ">", :ordering => "ASC", :next => 1}
        else
          raise WrongDirectionError
      end
      directional
    end

    def split_item_path(path)
      path = Section.split_section_path path
      [path[0...-2].join("/"), path.last]
    end

  end


  def shift(direction)
    directional = Section.shifting_array(direction)

    item = self
    if item.can_be_shifted? directional[:condition]
      next_item = Item.
          where(:section_id => item[:section_id]).
          where("position #{directional[:condition]} ?", item[:position]).
          order("position #{directional[:ordering]}").
          first

      item.increment(:position, directional[:next]).save
      next_item.increment(:position, -1 * directional[:next]).save
    else
      return false
    end

    next_item
  end


  def can_be_shifted?(condition)
    Item.
        where(:section_id => self[:section_id]).
        where("position #{condition} ?", self[:position]).
        count > 0
  end






  def set_position_if_not_set
    if self[:position].nil?
      self[:position] = Item.where(:section_id => self[:section_id]).maximum('position').to_i + 1
      unless self.valid?
        errors[:position] = I18n.t('models.item.wrong_position')
        return false
      end
    end

    true
  end


  def update_and_shift(attributes)
    old_parent_id = self[:section_id]
    old_position = self[:position]
    new_parent_id = attributes[:section_id].to_i

    self.attributes = attributes

    if old_parent_id != new_parent_id
      self[:position] = Item.where(:section_id => new_parent_id).maximum('position').to_i + 1

      if self.valid? and self.save
        Item.
          where('position >= ? AND section_id = ?', old_position, old_parent_id).
          update_all("position = position - 1")
      end
    else
      self.save
    end
  end


  def move_back_next_items
    Item.
        where('position > ? AND section_id = ?', self[:position], self[:section_id]).
        update_all("position = position - 1")
  end


end
