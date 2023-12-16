require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }

  setup { user }

  describe "valid params" do
    let(:order) { create(:order, user: user) }
    
    before { order }

    it "creates a record successfully" do
      expect(order).to be_valid
      expect(Order.find_by(id: order.id).present?).to be true
    end

    it "updates a record successfully" do
      updated_status = order.update(price: 12.90, quantity: 1, order_type: Order::BUY)

      expect(updated_status).to be true
      expect(order.price).to eq 12.90
      expect(order.quantity).to eq 1
      expect(order.order_type).to eq Order::BUY
    end

    it "destroys a record successfully" do
      order.destroy

      expect(Order.find_by(id: order.id)).to be nil
      expect(order.errors.empty?).to be true
    end
  end

  describe "invalid params" do
    context "missing user_id" do
      it "raises error" do
        expect { Order.create! }.to raise_error(ActiveRecord::RecordInvalid, /User must exist/)
      end
    end

    context "missing price" do
      let(:order) { build(:order, user: user, price: nil) }

      it "returns error message" do
        order.save
        expect(order.errors.full_messages).to include "Price can't be blank"
      end
    end

    context "missing quantity" do
      let(:order) { build(:order, user: user, quantity: nil) }

      it "returns error message" do
        order.save
        expect(order.errors.full_messages).to include "Quantity can't be blank"
      end
    end

    context "invalid status" do
      context "unknown status" do
        let(:order) { build(:order, user: user, status: "unknown") }
        it "returns error message" do
          order.save
          expect(order.errors.full_messages).to include "Status is not included in the list"
        end
      end
      
      context "missing status" do
        let(:order) { build(:order, user: user, status: nil) }
        it "returns error message" do
          order.save
          expect(order.errors.full_messages).to include "Status is not included in the list"
        end
      end
    end

    context "invalid order type" do
      context "unknown status" do
        let(:order) { build(:order, user: user, order_type: "unknown") }
        it "returns error message" do
          order.save
          expect(order.errors.full_messages).to include "Order type is not included in the list"
        end
      end
      
      context "missing status" do
        let(:order) { build(:order, user: user, order_type: nil) }
        it "returns error message" do
          order.save
          expect(order.errors.full_messages).to include "Order type is not included in the list"
        end
      end
    end
  end

  describe "query completed buy orders" do
    let(:order_1) { create(:order, order_type: Order::BUY, status: Order::COMPLETED, user: user) }
    let(:order_2) { create(:order, order_type: Order::BUY, status: Order::COMPLETED, user: user) }
    let(:order_3) { create(:order, order_type: Order::BUY, status: Order::COMPLETED, user: user) }

    let(:order_4) { create(:order, order_type: Order::SELL, status: Order::COMPLETED, user: user) }
    let(:order_5) { create(:order, order_type: Order::BUY, status: Order::PENDING, user: user) }


    setup do
      order_1
      order_2
      order_3
      order_4
      order_5
    end

    context "queries for completed buy orders" do
      it "return an array of orders" do
        result = Order.completed_buy_orders

        expect(result.size).to eq 3
        expect(result.include? order_1).to be true
        expect(result.include? order_2).to be true
        expect(result.include? order_3).to be true
      end
    end
  end

  describe "check if an order is processable" do
    context "processsable order" do
      let(:order) { create(:order, status: Order::COMPLETED, user: user) }

      before { order }

      it "returns true" do
        expect(order.processable?).to be true
      end
    end

    context "unprocesssable order" do
      let(:order) { build(:order, status: Order::CANCELED, user: user) }

      before { order }

      it "returns false" do
        order.save
        expect(order.processable?).to be false
        expect(order.errors.full_messages).to include "Order with id #{order.id} is canceled"
      end
    end
  end

  describe "process order" do
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
end