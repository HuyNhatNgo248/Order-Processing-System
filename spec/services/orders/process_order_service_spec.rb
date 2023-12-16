# frozen_string_literal: true

require 'rails_helper'

module Orders
  describe ProcessOrderService do
    let(:user) { create(:user) }

    setup { user }

    context "process order successfully" do
      context "completed order" do
        let(:order_1) { create(:order, status: Order::PENDING, user: user, order_type: Order::BUY, price: 100) }
        let(:order_2) { create(:order, status: Order::PENDING, user: user, order_type: Order::SELL, price: 100) }

        before do
          order_1
          order_2
        end

        it "updates status of order" do
          Order.process_order(order: order_1, threshold: 200)
          Order.process_order(order: order_2, threshold: 50)

          expect(order_1.status).to eq Order::COMPLETED
          expect(order_2.status).to eq Order::COMPLETED
        end
      end

      context "canceled order" do
        let(:order_1) { create(:order, status: Order::PENDING, user: user, order_type: Order::BUY, price: 100) }
        let(:order_2) { create(:order, status: Order::PENDING, user: user, order_type: Order::SELL, price: 100) }

        before do
          order_1
          order_2
        end

        it "updates status of order" do
          Order.process_order(order: order_1, threshold: 50)
          Order.process_order(order: order_2, threshold: 200)

          expect(order_1.status).to eq Order::CANCELED
          expect(order_2.status).to eq Order::CANCELED
        end
      end
    end

    context "fail to process order" do
      let(:order) { create(:order, status: Order::CANCELED, user: user, order_type: Order::BUY, price: 100) }

      before { order }

      it "return error message" do
        result = Orders::ProcessOrderService.call(order: order)
        
        expect(result.failure?).to be true
        expect(result.failure[:error_msg]).to eq "Order with id #{order.id} is canceled"
      end
    end
  end
end