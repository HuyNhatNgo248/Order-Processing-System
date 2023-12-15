# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :price
      t.integer :quantity
      t.string :order_type
      t.string :status

      t.timestamps
    end
  end
end
