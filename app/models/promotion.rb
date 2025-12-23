class Promotion < ApplicationRecord
    has_many :promotion_rules
    has_many :promotion_actions
    validates :name, presence: true
    validates :starts_at, presence: true
    validates :ends_at, presence: true
    enum :status, { active: 0, inactive: 1 }
    validates :status, inclusion: { in: statuses.keys }
    scope :active, -> { where("starts_at <= ? AND (ends_at IS NULL OR ends_at >= ?)", Time.current, Time.current) }
end
