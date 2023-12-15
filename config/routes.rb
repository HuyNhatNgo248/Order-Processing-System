# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :orders do
      member do
        patch 'process_order', to: "orders#process_order"
      end

      collection do
        get 'total_order_quantity', to: "orders#total_order_quantity"
      end
    end
  end
end
