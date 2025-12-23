class Api::V1::CartsController < ApplicationController
  def show
    cart = Cart.includes(cart_items: :item).find(params[:id])

    render json: CartSerializer.new(cart).as_json

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Cart not found" }, status: :not_found
  end
end
