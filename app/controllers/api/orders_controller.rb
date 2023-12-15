# frozen_string_literal: true

module Api
  # Controller responsible for handling orders in the API.
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update destroy process_order]
    before_action :set_user, only: %i[total_order_quantity]

    def index
      result = Order.all
      render_success(result)
    end

    def show
      render_success(@order)
    end

    def create
      result = Orders::CreateService.call(order_params:)

      render_json(result)
    end

    def update
      result = Orders::UpdateService.call(order: @order, order_params:)

      render_json(result)
    end

    def destroy
      result = Orders::DestroyService.call(order: @order)

      render_json(result)
    end

    def process_order
      result = Orders::ProcessOrderService.call(order: @order, threshold: params[:threshold])

      render_json(result)
    end

    def total_order_quantity
      order_quantity = Order.where(user: @user, status: Order::COMPLETED).count

      render_success({ total_quantity: order_quantity })
    end

    private

    def set_order
      @order = Order.find_by(id: params[:id])

      render_failure('Order not found') unless @order
    end

    def set_user
      @user = User.find_by(id: params[:user_id])

      render_failure('User not found') unless @user
    end

    def order_params
      params.require(:order).permit(:user_id, :price, :quantity, :order_type, :status)
    end
  end
end
