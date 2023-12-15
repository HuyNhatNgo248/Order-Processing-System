# frozen_string_literal: true

module ApplicationHelper
  def numeric?(str)
    /\A[+-]?\d+(\.\d+)?\z/.match? str
  end
end
