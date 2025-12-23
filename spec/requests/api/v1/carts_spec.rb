require 'rails_helper'

RSpec.describe "Api::V1::CartsController", type: :request do
  let!(:cart) { create(:cart) }

  let!(:item1) { create(:item, name: "Milk", price: 50, unit_type: "quantity") }
  let!(:item2) { create(:item, name: "Cheese", price: 10, unit_type: "weight") }

  let!(:cart_item1) { create(:cart_item, cart: cart, item: item1, quantity: 2, final_price: 100.0) }
  let!(:cart_item2) { create(:cart_item, cart: cart, item: item2, quantity: 5, final_price: 50.0) }

  before do
    cart.update!(total_price: cart.cart_items.sum(&:final_price))
  end

  describe "GET /api/v1/carts/:id" do
    context "when cart exists" do
      it "returns the cart with all items and total_price" do
        get "/api/v1/carts/#{cart.id}"

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        
        expect(json["cart_id"]).to eq(cart.id)
      end
    end

    context "when cart does not exist" do
      it "returns 404 not found" do
        get "/api/v1/carts/99999"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
