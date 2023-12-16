# frozen_string_literal: true

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
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
