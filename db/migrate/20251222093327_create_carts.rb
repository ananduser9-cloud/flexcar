class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.string :status
      t.decimal :total_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
