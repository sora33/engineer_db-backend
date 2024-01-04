# frozen_string_literal: true

module Api
  module V1
    class AvatarsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      def update
        current_user.avatar.attach(params[:avatar])
        if current_user.avatar.attached?
          render json: current_user, status: :ok
        else
          render json: { error: 'Failed to update avatar' }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.error e
        render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
      end
    end
  end
end
