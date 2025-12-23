require 'rails_helper'

RSpec.describe "Cart API", type: :request do

  let!(:item1) { create(:item) }

	let!(:cart) { create(:cart) }
  let!(:item2) { create(:item, price: 10, unit_type: "weight") }

  let!(:cart_item1) { create(:cart_item, cart: cart, item: item2, quantity: 2, final_price: 100.0) }


  describe "POST /api/v1/carts/new/cart_items" do

		it "adds an item into cart" do
			post "/api/v1/carts/new/cart_items", params: { item_id: item1.id, quantity: 2 }

			expect(response).to have_http_status(:ok)

			json = JSON.parse(response.body)

			expect(json["items"].first["name"]).to eq(item1.name)
		end
	end

	describe "DELETE /api/v1/carts/cart_items/:id" do
    it "removes the cart item and updates total_price" do
      delete "/api/v1/carts/#{cart.id}/cart_items/#{cart_item1.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["message"]).to eq("Item removed from cart")
    end

    it "returns 404 if cart item does not exist" do
      delete "/api/v1/carts/#{cart.id}/cart_items/9999"

      expect(response).to have_http_status(:not_found)
    end
  end

end
