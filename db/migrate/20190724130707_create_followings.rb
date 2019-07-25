class CreateFollowings < ActiveRecord::Migration[5.2]
  def change
    create_table :followings do |t|
      t.integer :followee_id, index: true
      t.integer :follower_id, index: true
    end
  end
end
