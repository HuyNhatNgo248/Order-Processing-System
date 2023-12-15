# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ApplicationRecord.transaction do
  user_1 = User.create(name: "John")
  user_2 = User.create(name: "Adam")

  order_1 = Order.create(user: user_1, price: 24.5, quantity: 40, order_type: Order::BUY, status: Order::PENDING)
  order_2 = Order.create(user: user_1, price: 195.23, quantity: 30, order_type: Order::BUY, status: Order::PENDING)
  order_3 = Order.create(user: user_1, price: 1500.42, quantity: 100, order_type: Order::BUY, status: Order::COMPLETED)
  order_4 = Order.create(user: user_1, price: 323.99, quantity: 50, order_type: Order::BUY, status: Order::COMPLETED)
  order_5 = Order.create(user: user_1, price: 323.99, quantity: 50, order_type: Order::SELL, status: Order::CANCELED)

  order_6 = Order.create(user: user_2, price: 224.50, quantity: 40, order_type: Order::BUY, status: Order::PENDING)
  order_7 = Order.create(user: user_2, price: 195.23, quantity: 30, order_type: Order::BUY, status: Order::PENDING)
  order_8 = Order.create(user: user_2, price: 1510.42, quantity: 100, order_type: Order::BUY, status: Order::COMPLETED)
  order_9 = Order.create(user: user_2, price: 363.99, quantity: 50, order_type: Order::BUY, status: Order::COMPLETED)
  order_10 = Order.create(user: user_2, price: 324.99, quantity: 50, order_type: Order::SELL, status: Order::CANCELED)  
end
