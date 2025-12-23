FactoryBot.define do
    factory :item do
      sequence(:name) { |n| "Item #{n}" }
      price { rand(10..50) }
      unit_type { [ :quantity, :weight ].sample }
      active { true }
      association :category
      association :brand
    end
  end
