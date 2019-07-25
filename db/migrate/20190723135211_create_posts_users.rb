class CreatePostsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :user_id, index: true
      t.integer :post_id, index: true
      t.integer :stars, default: 3
      t.timestamps
    end
  end
end
