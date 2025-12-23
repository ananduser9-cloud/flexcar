class CreatePromotions < ActiveRecord::Migration[8.1]
  def change
    create_table :promotions do |t|
      t.string :name
      t.integer :status
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
