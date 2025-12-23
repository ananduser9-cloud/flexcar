FactoryBot.define do
    factory :promotion_action do
      association :promotion
      action_type { 0 }  # 0 = flat, 1 = percentage
      value { 5 }
    end
  end
