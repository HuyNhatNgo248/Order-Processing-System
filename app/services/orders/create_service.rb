# frozen_string_literal: true

module Orders
  class CreateService < BaseService
    def initialize(order_params:)
      @order_params = order_params
    end

    def call
      create_order
    end

    private

    attr_reader :order_params

    def create_order
      order = Order.create(order_params)
      return Failure(error_msg: model_error(order)) if order.errors.any?

      Success(order)
    end
  end
end
