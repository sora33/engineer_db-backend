# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]
      before_action :find_or_initialize_user, only: [:create]
      before_action :set_user, only: %i[show update]
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      def index
        users = filter_and_sort_users
        total_count = users.count
        users = paginate(users)
        serialized_users = ActiveModelSerializers::SerializableResource.new(users).as_json
        render json: { users: serialized_users, totalCount: total_count }
      end

      def show
        render json: @user
      end

      def create
        if @user.save
          render json: @user
        else
          render_error
        end
      rescue StandardError => e
        handle_standard_error(e)
      end

      def update
        unless @user == current_user
          return render json: { error: 'You can only update your own profile.' }, status: :forbidden
        end

        if @user.update(user_update_params)
          render json: @user
        else
          render_error
        end
      rescue StandardError => e
        handle_standard_error(e)
      end

      def destroy
        current_user.destroy
        head :no_content
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
                                     :experience, :gender, :location, :website)
      end

      def filter_and_sort_users
        users = User.includes(:skills, :avatar_attachment).where.not(id: current_user.id).order(last_sign_in_at: :desc)
        users = apply_search_params(users)
        apply_skill_params(users)
      end

      def apply_search_params(users)
        search_params = params.permit(:gender, :location, :purpose, :work, :occupation)
        search_params.each do |key, value|
          users = users.where(key => value) if value.present?
        end
        users
      end

      def apply_skill_params(users)
        skill = params[:skill]
        skill_level = params[:skillLevel]
        if skill.present? && skill_level.present?
          users = users.joins(:skills).where('skills.name = ? AND skills.level >= ?', skill, skill_level)
        end
        users
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
