class Item < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :unit_type, presence: true
  validates :category, presence: true
  validates :active, inclusion: { in: [ true, false ] }
  enum :unit_type, { quantity: 0, weight: 1 }
  validates :unit_type, inclusion: { in: unit_types.keys }
end
