class Comment < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  attr_accessible :text, :visible, :item_id, :created_at, :updated_at,
                  :user_id, :provider, :name
end
