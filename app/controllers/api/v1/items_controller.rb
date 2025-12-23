class Api::V1::ItemsController < ApplicationController
    def index
      items = Item.all

      render json: items.as_json(only: [ :id, :name, :price, :unit_type, :category_id, :brand_id, :active ])
    end
end
