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
class Order < ApplicationRecord
  belongs_to :user

  ORDER_TYPES = [
    BUY = 'buy',
    SELL = 'sell'
  ].freeze

  STATUSES = [
    PENDING = 'pending',
    COMPLETED = 'completed',
    CANCELED = 'canceled'
  ].freeze

  validates :order_type, inclusion: { in: ORDER_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :price, presence: true
  validates :quantity, presence: true

  scope :completed_buy_orders, lambda {
    where(order_type: BUY, status: COMPLETED)
  }

  def self.process_order(order:, threshold:)
    return order unless order.processable?

    status = get_status(order, threshold)

    order.update(status: status)
  end

  def processable?
    return true if present? && status != CANCELED

    if blank?
      errors.add(:base, 'Order must exist to process')
      Rails.logger.error('Order must exist to process')
    else
      errors.add(:base, "Order with id #{id} is canceled")
      Rails.logger.error("Order with id #{id} is canceled")
    end

    false
  end

  def self.get_status(order, threshold)
    if (order.order_type == BUY && order.price < threshold.to_f) ||
       (order.order_type == SELL && order.price > threshold.to_f)
      COMPLETED
    else
      CANCELED
    end
  end
end
