# frozen_string_literal: true

module Orders
  class UpdateService < BaseService
    def initialize(order:, order_params:)
      @order = order
      @order_params = order_params
    end

    def call
      update_order
    end

    private

    attr_reader :order, :order_params

    def update_order
      order.update(order_params)
      return Failure(error_msg: model_error(order)) if order.errors.any?

      Success(order)
    end
  end
end
