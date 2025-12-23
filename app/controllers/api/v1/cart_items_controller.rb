class Api::V1::CartItemsController < ApplicationController
  def create
    cart = find_or_create_cart
    item = Item.find(params[:item_id])
    quantity = params[:quantity].to_d

    raise ArgumentError, "Quantity must be greater than 0" if quantity <= 0

    cart_item = cart.cart_items.find_or_initialize_by(item: item)
    cart_item.quantity ||= 0
    cart_item.quantity += quantity
    cart_item.save!

    CartPricingService.new(cart).reprice!

    render json: CartSerializer.new(cart).as_json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Item not found" }, status: :not_found
  rescue ArgumentError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy

    render json: { message: "Item removed from cart" }
  end

    private

    def find_or_create_cart
      return Cart.find(params[:cart_id]) if params[:cart_id] != "new"

      Cart.create!(status: "active")
    end
end
