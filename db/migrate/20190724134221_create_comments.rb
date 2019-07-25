class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :content
      t.timestamps
      t.integer :commentable_id
      t.string :commentable_type
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
