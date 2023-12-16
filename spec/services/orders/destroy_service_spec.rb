# frozen_string_literal: true

require 'rails_helper'

module Orders
  describe DestroyService do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    setup do
      user
      order
    end

    context "destroy record successfully" do
      it 'returns order object' do
        freeze_time do
          described_class.call(order: order)
          expect(user.orders).not_to include(order)
          expect(Order.find_by(id: order.id).present?).to be false
        end
      end
    end
  end
end