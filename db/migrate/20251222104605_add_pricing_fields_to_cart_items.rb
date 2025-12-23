class AddPricingFieldsToCartItems < ActiveRecord::Migration[8.1]
  def change
    add_column :cart_items, :unit_price, :decimal, precision: 10, scale: 2
    add_column :cart_items, :discount_amount, :decimal, precision: 10, scale: 2
    add_column :cart_items, :final_price, :decimal, precision: 10, scale: 2
    add_column :cart_items, :applied_promotion_id, :bigint
  end
end
