# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    decoded_token = decode_token_from_header

    if decoded_token
      check_token_expiry(decoded_token)
      find_current_user(decoded_token)
    else
      render_unauthorized
    end
  end

  def decode(token)
    next_auth_secret = ENV.fetch('NEXTAUTH_SECRET', nil)
    hkdf = HKDF.new(next_auth_secret, salt: '', algorithm: 'sha256', info: 'NextAuth.js Generated Encryption Key')
    key = hkdf.read(32)
    decrypt = JWE.decrypt(token, key)
    JSON.parse(decrypt)
  rescue StandardError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end

  def decode_token_from_header
    auth_header = request.headers['Authorization']
    token = auth_header.split.last if auth_header
    decode(token)
  end

  def check_token_expiry(decoded_token)
    return unless decoded_token['exp'] && Time.zone.at(decoded_token['exp']) < Time.zone.now

    render json: { error: 'Token has expired' }, status: :unauthorized
    nil
  end

  def find_current_user(decoded_token)
    @current_user = User.find_by(provider: decoded_token['provider'], id: decoded_token['providerUserId'])
    if @current_user
      if @current_user.last_sign_in_at.nil? || @current_user.last_sign_in_at < 10.minutes.ago
        @current_user.update(last_sign_in_at: Time.zone.now)
      end
    else
      render_unauthorized
    end
  end

  def render_unauthorized
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render json: { error: 'Record not found' }, status: :not_found
  end

  rescue_from StandardError do |_exception|
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end
end
