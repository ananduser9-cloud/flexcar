# app/services/promotion_evaluator.rb
require "ostruct"

class PromotionEvaluator
    def initialize(cart_item, used_promotions = Set.new)
      @cart_item = cart_item
      @used_promotions = used_promotions
    end

    # Returns nil if no eligible promotion exists or all eligible promotions are already used
    def best_eligible_promotion
      eligible = Promotion.active.select { |promo| valid_for_item?(promo) && !@used_promotions.include?(promo.id) }
      return nil if eligible.empty?

      best_promo = eligible.map { |promo| apply_promotion(promo) }.max_by(&:discount_amount)
      best_promo
    end

    private

    def valid_for_item?(promotion)
      # Check rules
      promotion.promotion_rules.any? do |rule|
        rule_matches = case rule.rule_type
        when "category"
          @cart_item.item.category_id == rule.reference_id.to_i
        when "item"
          @cart_item.item_id == rule.reference_id.to_i
        else
          false
        end

        # Check min_value criterion if present
        min_value_matches = rule.min_value.nil? || @cart_item.quantity >= rule.min_value

        rule_matches && min_value_matches
      end
    end

    def apply_promotion(promotion)
      # Compute discount amount
      discount = promotion.promotion_actions.sum do |action|
        case action.action_type
        when "flat_fee"
          action.value.to_f
        when "percentage"
          @cart_item.quantity * @cart_item.item.price * (action.value.to_f / 100)
        else
          0
        end
      end

      OpenStruct.new(promotion: promotion, discount_amount: discount)
    end
end
