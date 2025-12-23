# app/serializers/cart_serializer.rb
class CartSerializer
  def initialize(cart)
    @cart = cart
  end

  def as_json
    {
      cart_id: @cart.id,
      total_price: total_price,
      items: items_json
    }
  end

  private

  def items_json
    @cart.cart_items.map do |ci|
      {
        cart_item_id: ci.id,
        item_id: ci.item.id,
        name: ci.item.name,
        unit_type: ci.item.unit_type,
        unit: ci.item.unit,
        quantity: ci.quantity,
        price: ci.final_price,
        applied_promotion: ci.promotion_name
      }
    end
  end

  def total_price
    @cart.cart_items.sum(&:final_price)
  end
end
