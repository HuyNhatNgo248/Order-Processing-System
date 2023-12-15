# frozen_string_literal: true

require 'dry/monads'

class BaseService
  include Dry::Monads[:result, :do]
  include ApplicationHelper

  def self.call(**args, &block)
    new(**args, &block).call
  end

  protected

  def model_error(model)
    model.errors.full_messages.join(', ')
  end
end
