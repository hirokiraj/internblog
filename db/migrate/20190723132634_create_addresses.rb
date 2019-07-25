class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :city
      t.string :postal_code
      t.string :street
      t.string :street_number
      t.integer :author_id, index: true
      t.timestamps
    end
  end
end
