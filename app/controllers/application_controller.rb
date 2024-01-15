# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Paginatable
  attr_reader :current_user

  before_action :authenticate_request

  rescue_from StandardError, with: :handle_internal_server_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from JWT::ExpiredSignature, with: :handle_token_expired

  private

  def authenticate_request
    @current_user = authenticate_user_from_token(token_from_header)
    render_unauthorized unless @current_user
  end

  def authenticate_user_from_token(token)
    return unless token && (decoded_token = decode_token(token))
    return unless token_not_expired?(decoded_token)

    User.authenticate_from_token(decoded_token)
  end

  def token_from_header
    request.headers['Authorization']&.split&.last
  end

  def decode_token(token)
    next_auth_secret = ENV.fetch('NEXTAUTH_SECRET', nil)
    hkdf = HKDF.new(next_auth_secret, salt: '', algorithm: 'sha256', info: 'NextAuth.js Generated Encryption Key')
    key = hkdf.read(32)
    decrypt = JWE.decrypt(token, key)
    JSON.parse(decrypt)
  rescue StandardError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end

  def token_not_expired?(decoded_token)
    expiry_time = Time.zone.at(decoded_token['exp'])
    expiry_time > Time.zone.now
  end

  def find_current_user(decoded_token)
    User.find_by(provider: decoded_token['provider'], id: decoded_token['id']).tap do |user|
      update_last_sign_in(user) if user
    end
  end

  def update_last_sign_in(user)
    return true if user.last_sign_in_at && user.last_sign_in_at >= 10.minutes.ago

    user.update(last_sign_in_at: Time.zone.now)
  end

  def render_unauthorized
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  def handle_token_expired
    render json: { error: 'Token has expired' }, status: :unauthorized
  end

  def handle_internal_server_error(_exception)
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def record_not_found
    render plain: '404 Not Found', status: :not_found
  end

  rescue_from StandardError do |_exception|
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
