# frozen_string_literal: true

module Api
  module V1
    class SkillsController < ApplicationController
      before_action :set_user, only: %i[show update]

      def show
        render json: @user.skills
      end

      def update
        if @user == current_user
          if @user.update_skills(skill_params[:skills])
            render json: current_user.skills
          else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'You can only update your own skills.' }, status: :forbidden
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      def skill_params
        params.permit(skills: %i[name level])
      end
    end
  end
end
