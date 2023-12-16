# frozen_string_literal: true

require 'rails_helper'

module Orders
  describe UpdateService do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    setup do
      user
      order
    end

    context "update record successfully" do
      let(:order_params) do
        {
          price: 10,
          quantity: 5,
          status: Order::PENDING
        }
      end

      it "returns an order object" do
        result = described_class.call(order: order, order_params: order_params)

        expect(result.success?).to be true
        expect(result.success.price).to eq 10
        expect(result.success.quantity).to eq 5
        expect(result.success.status).to eq Order::PENDING
      end
    end

    context "fail to update record" do
      let(:order_params) do
        {
          status: "unknown" #expect error
        }
      end

      it "returns error message" do
        result = described_class.call(order: order, order_params: order_params)

        expect(result.failure?).to be true
        expect(result.failure[:error_msg]).to eq "Status is not included in the list"
      end
    end
  end
end