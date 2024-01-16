# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from JWT::ExpiredSignature, with: :handle_unauthorized
  end

  private

  def handle_unauthorized(message = 'Not Authorized')
    render_error(message, :unauthorized)
  end

  def handle_error(_exception)
    render_error('Internal server error', :internal_server_error)
  end

  def handle_not_found(_exception)
    render_error('Not Found', :not_found)
  end

  def render_error(message, status)
    render json: { error: message }, status:
  end
end
