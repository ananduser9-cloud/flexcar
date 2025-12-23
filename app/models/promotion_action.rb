class PromotionAction < ApplicationRecord
  belongs_to :promotion
  validates :action_type, presence: true
  validates :value, presence: true
  enum :action_type, { flat_fee: 0, percentage: 1, bogo: 2 }
  validates :action_type, inclusion: { in: action_types.keys }
  validates :value, numericality: { greater_than: 0 }
end
