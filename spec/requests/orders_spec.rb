# frozen_string_literal: true

require 'rails_helper'

module Api
  describe OrdersController, type: :controller do
    describe 'Orders API' do
      let(:user) { create(:user) }
      let(:order_1) { create(:order, user: user, order_type: Order::BUY, price: 100, status: Order::PENDING) }
      let(:order_2) { create(:order, user: user, status: Order::CANCELED) }
      let(:order_3) { create(:order, user: user, status: Order::COMPLETED, order_type: Order::BUY) }
      let(:order_4) { create(:order, user: user, status: Order::COMPLETED, order_type: Order::BUY) }
  
      setup do
        user
        order_1
        order_2
        order_3
        order_4
      end
  
      
      context "get all orders" do
        it "return success" do
          get :index
          result = JSON.parse(response.body, symbolize_names: true)
    
          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data].size).to eq 4
        end
      end

      context "create an order" do
        let(:valid_order_params) do
          {
            order: {
              user_id: user.id,
              price: 1,
              quantity: 1,
              order_type: Order::BUY, 
              status: Order::PENDING,
            }
          }
        end

        let(:invalid_order_params) do
          {
            order: {
              user_id: user.id,
              quantity: 1,
              order_type: Order::BUY, 
              status: Order::PENDING,
            }
          }
        end

        it "return success" do
          post :create, params: valid_order_params
          result = JSON.parse(response.body, symbolize_names: true)
  
          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data][:user_id]).to eq user.id
          expect(result[:data][:price]).to eq "1.0"
        end

        it "return failure" do
          post :create, params: invalid_order_params
          result = JSON.parse(response.body, symbolize_names: true)
  
          expect(response).to have_http_status(:unprocessable_entity)
          expect(result[:success]).to be false
          expect(result[:error]).to eq "Price can't be blank"
        end
      end

      context "show an order" do
        it "return success" do
          get :show, params: { id: order_1.id }
          result = JSON.parse(response.body, symbolize_names: true)
          
          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data][:id]).to eq order_1.id
        end

        it "return failure" do
          get :show, params: { id: "invalid" }
          result = JSON.parse(response.body, symbolize_names: true)
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(result[:success]).to be false
          expect(result[:error]).to eq "Order not found"
        end
      end

      context "update an order" do
        let(:order_params) do
          {
            order: {
              price: 100
            }
          }
        end

        it "return success" do
          patch :update, params: order_params.merge({ id: order_1.id })
          result = JSON.parse(response.body, symbolize_names: true)
          
          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data][:price]).to eq "100.0"
        end

        it "return failure" do
          get :update, params: order_params.merge({ id: "invalid" })
          result = JSON.parse(response.body, symbolize_names: true)
          
          expect(response).to have_http_status(:unprocessable_entity)
          expect(result[:success]).to be false
          expect(result[:error]).to eq "Order not found"
        end
      end

      context "destroy an order" do
        it "return success" do
          delete :destroy, params: { id: order_1.id }
          result = JSON.parse(response.body, symbolize_names: true)
          
          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data][:id]).to eq order_1.id
          expect(Order.find_by(id: order_1.id).present?).to be false
        end
      end

      context "process order" do
        
        it "return success" do
          patch :process_order, params: { id: order_1.id, threshold: 200 }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data][:status]).to eq Order::COMPLETED
        end

        it "return failure" do
          patch :process_order, params: { id: order_2.id }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(result[:success]).to be false
          expect(result[:error]).to eq "Order with id #{order_2.id} is canceled"
        end
      end

      context "get total order quantity" do
        it "return success" do
          get :completed_buy_orders
          result = JSON.parse(response.body, symbolize_names: true)

          expect(response).to have_http_status(:success)
          expect(result[:success]).to be true
          expect(result[:data].size).to eq 2
        end
      end
    end
  end
end