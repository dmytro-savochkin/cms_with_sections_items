class Comment < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  attr_accessible :text, :visible, :item_id, :created_at, :updated_at,
                  :user_id, :provider, :name

  validates_presence_of :text

  paginates_per 10
end
