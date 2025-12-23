# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data (optional, for repeated seeding)
# Clear existing data
CartItem.delete_all
Cart.delete_all
Item.delete_all
Brand.delete_all
Category.delete_all
PromotionAction.delete_all
PromotionRule.delete_all
Promotion.delete_all

# Create brands
brands = []
5.times do |i|
  brands << Brand.create!(name: "Brand #{i + 1}")
end

# Create categories
categories = []
5.times do |i|
  categories << Category.create!(name: "Category #{i + 1}")
end

# Create items
unit_types = [ :quantity, :weight ]
items = []

5.times do |i|
  items << Item.create!(
    name: "Item #{i + 1}",
    price: (10 + i * 5),
    unit_type: unit_types.sample,
    category: categories.sample,
    brand: brands.sample,
    active: true
  )
end

puts "Seeded #{Brand.count} brands, #{Category.count} categories, #{Item.count} items."

# -------------------
# Promotions
# -------------------

# Flat fee promotion: $5 off on first item
promo1 = Promotion.create!(
  name: "Flat $5 Off",
  starts_at: 1.day.ago,
  ends_at: 1.week.from_now,
  status: 0
)

PromotionRule.create!(
  promotion: promo1,
  rule_type: 1,
  reference_id: items.first.id
)

PromotionAction.create!(
  promotion: promo1,
  action_type: 0,
  value: 5
)

# Percentage discount promotion: 10% off for category 1
promo2 = Promotion.create!(
  name: "10% Off Category 1",
  starts_at: 1.day.ago,
  ends_at: 1.week.from_now,
  status: 0
)

PromotionRule.create!(
  promotion: promo2,
  rule_type: 0,
  reference_id: categories.first.id
)

PromotionAction.create!(
  promotion: promo2,
  action_type: 1,
  value: 10
)

# Buy 1 Get 1 free on second item
promo3 = Promotion.create!(
  name: "Buy 1 Get 1 Free",
  starts_at: 1.day.ago,
  ends_at: 1.week.from_now,
  status: 0
)

PromotionRule.create!(
  promotion: promo3,
  rule_type: 1,
  reference_id: items.second.id
)

PromotionAction.create!(
  promotion: promo3,
  action_type: 2, # buy one get one
  value: 1
)

puts "Seeded #{Promotion.count} promotions with rules and actions."


# 50% off if weight is more than 100 grams
category = Category.find_or_create_by!(name: "Dry Fruits")
brand = Brand.find_or_create_by!(name: "Generic Brand")

almonds = Item.create!(
  name: "Almonds",
  category: category,
  brand: brand,
  unit_type: :weight,
  unit: "gram",
  price: 0.02, # ₹0.02 per gram
  active: true
)

promo4 = Promotion.create!(
  name: "Almond Weight Discount",
  starts_at: 1.day.ago,
  ends_at: 1.month.from_now,
  status: 0,
)

PromotionRule.create!(
  promotion: promo4,
  rule_type: 1,
  reference_id: almonds.id,
  min_value: 100 # grams
)

PromotionAction.create!(
  promotion: promo4,
  action_type: 1,
  value: 50
)
