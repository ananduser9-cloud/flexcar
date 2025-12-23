class Api::V1::CartsController < ApplicationController
  def show
    cart = Cart.includes(cart_items: :item).find(params[:id])

    render json: CartSerializer.new(cart).as_json
  end
end
