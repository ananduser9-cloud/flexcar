FactoryBot.define do
    factory :promotion_rule do
      association :promotion
      rule_type { 1 }         # 1 = item, 0 = category
      reference_id { create(:item).id }
    end
  end
