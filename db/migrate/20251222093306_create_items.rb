class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.integer :unit_type
      t.references :category, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
