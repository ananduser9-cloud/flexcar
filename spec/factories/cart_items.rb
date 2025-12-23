FactoryBot.define do
    factory :cart_item do
      association :cart
      association :item
      quantity { 1.0 }
      unit_price { item.price }
      final_price { item.price * quantity }
    end
  end
