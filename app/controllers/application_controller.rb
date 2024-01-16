# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Paginatable
  include ErrorHandler

  attr_reader :current_user

  before_action :authenticate_request

  private

  def authenticate_request
    @current_user = authenticate_user_from_token(token_from_header)
    handle_unauthorized('Not Authorized') unless @current_user
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
    TokenDecoder.new(token).decode
  end

  def token_not_expired?(decoded_token)
    expiry_time = Time.zone.at(decoded_token['exp'])
    expiry_time > Time.zone.now
  end
end

class TokenDecoder
  def initialize(token)
    @token = token
    @next_auth_secret = ENV.fetch('NEXTAUTH_SECRET', nil)
  end

  def decode
    hkdf = HKDF.new(@next_auth_secret, salt: '', algorithm: 'sha256', info: 'NextAuth.js Generated Encryption Key')
    key = hkdf.read(32)
    decrypt = JWE.decrypt(@token, key)
    JSON.parse(decrypt)
  rescue StandardError => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end
end
