# frozen_string_literal: true

module Api
  module V1
    class SkillsController < ApplicationController
      before_action :set_user, only: %i[show]

      def show
        render json: @user.skills
      end

      def update
        params[:skills].each do |skill_param|
          skill = current_user.skills.find_or_initialize_by(name: skill_param[:name])
          render json: skill.errors, status: :unprocessable_entity unless skill.update(level: skill_param[:level])
        end
        render json: current_user.skills
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
