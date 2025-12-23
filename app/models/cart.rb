class Cart < ApplicationRecord
    has_many :cart_items
    validates :status, presence: true
end
