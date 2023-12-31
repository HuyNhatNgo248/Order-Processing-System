# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :orders do
      member do
        patch 'process_order', to: "orders#process_order"
      end

      collection do
        get 'total_order_quantity', to: "orders#total_order_quantity"
        get 'completed_buy_orders', to: "orders#completed_buy_orders"
      end
    end
  end
end
