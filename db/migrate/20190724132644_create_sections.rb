class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.string :title
      t.integer :post_id, index: true
      t.timestamps
    end
  end
end
