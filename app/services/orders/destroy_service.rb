# frozen_string_literal: true

module Orders
  class DestroyService < BaseService
    def initialize(order:)
      @order = order
    end

    def call
      destroy_order
    end

    private

    attr_reader :order

    def destroy_order
      order.destroy
      return Failure(error_msg: model_error(order)) if order.errors.any?

      Success(order)
    end
  end
end
