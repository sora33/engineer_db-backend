# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]
      before_action :find_or_initialize_user, only: [:create]
      before_action :set_user, only: %i[show update]

      def index
        user = User.all
        render json: user
      end

      def show
        render json: @user
      end

      def create
        @user.last_sign_in_at = Time.zone.now

        if @user.save
          render json: @user
        else
          render_error
        end
      rescue StandardError => e
        handle_standard_error(e)
      end

      def update
        if @user.update(user_update_params)
          render json: @user
        else
          render_error
        end
      rescue StandardError => e
        handle_standard_error(e)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def find_or_initialize_user
        @user = User.find_or_initialize_by(provider: user_create_params[:provider],
                                           provider_id: user_create_params[:provider_id])
        return unless @user.new_record?

        @user.assign_attributes(name: user_create_params[:name])
      end

      def user_create_params
        params.require(:user).permit(:provider, :provider_id, :name)
      end

      def user_update_params
        params.require(:user).permit(:name, :purpose, :comment, :work, :occupation, :introduction, :hobby, :birthday,
                                     :location, :website)
      end

      def render_error
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end

      def handle_standard_error(error)
        render json: { error: error.message }, status: :internal_server_error
      end
    end
  end
end
