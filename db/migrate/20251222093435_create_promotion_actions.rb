class CreatePromotionActions < ActiveRecord::Migration[8.1]
  def change
    create_table :promotion_actions do |t|
      t.references :promotion, null: false, foreign_key: true
      t.integer :action_type
      t.decimal :value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
