# frozen_string_literal: true

require 'rails_helper'

module Orders
  describe CreateService do
    let(:user) { create(:user) }

    setup { user }

    context "create record successfully" do
      let(:order_params) do
        {
          user_id: user.id,
          price: 10,
          quantity: 1,
          order_type: Order::BUY,
          status: Order::PENDING
        }
      end

      it "returns an order object" do
        result = described_class.call(order_params: order_params)

        expect(result.success?).to be true
        expect(Order.find_by(user_id: user.id).present?).to be true
        expect(result.success.user_id).to eq user.id
        expect(result.success.price).to eq 10
        expect(result.success.quantity).to eq 1
        expect(result.success.order_type).to eq Order::BUY
        expect(result.success.status).to eq Order::PENDING
      end
    end

    context "fail to create record" do
      let(:order_params) do
        {
          user_id: user.id,
          price: nil, # expect error
          quantity: 1,
          order_type: Order::BUY,
          status: Order::PENDING
        }
      end

      it "returns an error message" do
        result = described_class.call(order_params: order_params)

        expect(result.failure?).to be true
        expect(Order.find_by(user_id: user.id).present?).to be false
        expect(result.failure[:error_msg]).to eq "Price can't be blank"
      end
    end
  end
end