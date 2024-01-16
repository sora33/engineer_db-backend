# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]
      before_action :find_or_initialize_user, only: [:create]
      before_action :set_user, only: %i[show update destroy]

      def index
        users = User.filter_and_sort(params.except(:format), current_user)
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
          render_error(@user.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def update
        if @user != current_user
          return render json: { error: 'You can only update your own profile.' }, status: :forbidden
        end

        if @user.update(user_update_params)
          render json: @user
        else
          render_error(@user.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def destroy
        if @user != current_user
          return render json: { error: 'You can only delete your own profile.' }, status: :forbidden
        end

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

        @user.assign_attributes(name: user_create_params[:name], provider_name: user_create_params[:name])
      end

      def user_create_params
        params.require(:user).permit(:provider, :provider_id, :name)
      end

      def user_update_params
        params.require(:user).permit(:name, :purpose, :comment, :work, :occupation, :introduction, :hobby, :birthday,
                                     :experience, :gender, :location, :website)
      end
    end
  end
end
