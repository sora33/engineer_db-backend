# frozen_string_literal: true

module Api
  module V1
    module Users
      class PostsController < ApplicationController
        def index
          user = User.find(params[:user_id])
          @posts = paginate(user.posts.order(created_at: :desc))

          render json: @posts
        end
      end
    end
  end
end
