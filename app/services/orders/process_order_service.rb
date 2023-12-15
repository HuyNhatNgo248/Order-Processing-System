# frozen_string_literal: true

module Orders
  class ProcessOrderService < BaseService
    def initialize(order:, threshold:)
      @order = order
      @threshold = threshold
    end

    def call
      process_order
    end

    private

    attr_reader :order, :threshold

    def process_order
      processed_order = Order.process_order(order: order, threshold: validated_threshold)
      return Failure(error_msg: model_error(processed_order)) if processed_order.errors.any?

      Success(processed_order)
    end

    def validated_threshold
      return ENV.fetch('DEFAULT_THRESHOLD', nil) unless threshold.present? && numeric?(threshold.to_s)

      threshold
    end
  end
end
