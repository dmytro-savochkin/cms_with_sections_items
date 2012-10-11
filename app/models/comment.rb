class Comment < ActiveRecord::Base
  belongs_to :item

  attr_accessible :user, :text, :visible, :item_id, :position, :created_at, :updated_at
end
