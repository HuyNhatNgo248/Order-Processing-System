# frozen_string_literal: true

# Controller responsible for rendering either success or failure response
class ApplicationController < ActionController::API

  def render_success(data, status = :ok)
    render json: { success: true, data: }, status:
  end

  def render_failure(message, status = :unprocessable_entity)
    render json: { success: false, error: message }, status:
  end

  def render_json(result)
    result.success? ? render_success(result.success) : render_failure(result.failure[:error_msg])
  end
end
