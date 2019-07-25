class Following < ApplicationRecord
  belongs_to :followed_user, class_name: 'User', foreign_key: 'follower_id'
  belongs_to :followee, class_name: 'User', foreign_key: 'followee_id'
end
