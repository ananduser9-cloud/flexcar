class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item
  belongs_to :applied_promotion, class_name: "Promotion", optional: true
end
