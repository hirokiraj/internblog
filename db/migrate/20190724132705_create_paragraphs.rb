class CreateParagraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :paragraphs do |t|
      t.text :content
      t.integer :section_id, index: true
      t.timestamps
    end
  end
end
