FactoryBot.define do
    factory :promotion do
      sequence(:name) { |n| "Promotion #{n}" }
      starts_at { 1.day.ago }
      ends_at { 1.week.from_now }
      status { 0 }  # assuming 0 = active

      # Factory trait for flat discount
      trait :flat_discount do
        after(:create) do |promo|
          create(:promotion_rule, promotion: promo, rule_type: 1, reference_id: create(:item).id)
          create(:promotion_action, promotion: promo, action_type: 0, value: 5)
        end
      end

      # Factory trait for percentage discount on category
      trait :percentage_category do
        after(:create) do |promo|
          create(:promotion_rule, promotion: promo, rule_type: 0, reference_id: create(:category).id)
          create(:promotion_action, promotion: promo, action_type: 1, value: 10) # assuming 1 = percentage
        end
      end
    end
  end
