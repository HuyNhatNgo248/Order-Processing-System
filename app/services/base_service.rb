# frozen_string_literal: true

require 'dry/monads'

class BaseService
  include Dry::Monads[:result, :do]

  def self.call(**args, &)
    new(**args, &).call
  end

  protected

  def model_error(model)
    model.errors.full_messages.join(', ')
  end
end
