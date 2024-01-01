# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      def index
        render json: {
          age_distribution: User.age_distribution,
          purpose_distribution: User.purpose_distribution,
          occupation_distribution: User.occupation_distribution,
          work_distribution: User.work_distribution
        }
      end
    end
  end
end
