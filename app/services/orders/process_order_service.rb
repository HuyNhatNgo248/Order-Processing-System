# frozen_string_literal: true

module Orders
  class ProcessOrderService < BaseService
    def initialize(order:)
      @order = order
    end

    def call
      process_order
    end

    private

    attr_reader :order

    def process_order
      processed_order = Order.process_order(order)
      return Failure(error_msg: model_error(processed_order)) if processed_order.errors.any?

      Success(processed_order)
    end
  end
end
