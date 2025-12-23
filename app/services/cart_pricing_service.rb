class CartPricingService
    def initialize(cart)
      @cart = cart
    end

    def reprice!
      reset_prices
      apply_promotions
      finalize_totals
    end

    private

    def reset_prices
      @cart.cart_items.each do |ci|
        ci.unit_price = ci.item.price
        ci.discount_amount = 0
        ci.applied_promotion_id = nil
        ci.final_price = ci.item.price * ci.quantity
        ci.save!
      end
    end

    def apply_promotions
      used_promotions = Set.new

      @cart.cart_items.each do |cart_item|
        # Each item gets only one promotion (the best eligible one)
        # Only one instance of each promotion can be applied at a time
        best = PromotionEvaluator.new(cart_item, used_promotions).best_eligible_promotion
        next unless best

        cart_item.discount_amount = best.discount_amount
        cart_item.final_price -= best.discount_amount
        cart_item.applied_promotion_id = best.promotion.id

        # Mark this promotion as used so it cannot be applied to another item
        used_promotions.add(best.promotion.id)
        cart_item.save!
      end
    end

    def finalize_totals
      @cart.update!(total_price: @cart.cart_items.sum(&:final_price))
    end
end
