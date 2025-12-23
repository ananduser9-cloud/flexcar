class PromotionRule < ApplicationRecord
  belongs_to :promotion
  validates :rule_type, presence: true
  validates :reference_id, presence: true
  # validates :min_value, presence: true
  enum :rule_type, { category: 0, item: 1 }
  validates :rule_type, inclusion: { in: rule_types.keys }
  validates :reference_id, numericality: { only_integer: true }
  # validates :min_value, numericality: { greater_than: 0 }
end
