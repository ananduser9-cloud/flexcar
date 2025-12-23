class CreatePromotionRules < ActiveRecord::Migration[8.1]
  def change
    create_table :promotion_rules do |t|
      t.references :promotion, null: false, foreign_key: true
      t.integer :rule_type
      t.bigint :reference_id
      t.decimal :min_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
