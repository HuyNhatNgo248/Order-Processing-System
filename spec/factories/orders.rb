# == Schema Information
#
# Table name: orders
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  price      :decimal(, )
#  quantity   :integer
#  order_type :string           default("buy"), not null
#  status     :string           default("sell"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :order do
    association :user
    price { Faker::Number.decimal(l_digits: 3) }
    quantity { Faker::Number.number(digits: 2) }
    order_type { [Order::BUY, Order::SELL].sample }
    status { [Order::PENDING, Order::COMPLETED, Order::CANCELED].sample }
  end
end
