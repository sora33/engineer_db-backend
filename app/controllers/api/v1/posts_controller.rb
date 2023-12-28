# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[destroy]

      def index
        limit = 10
        page = params[:page].to_i
        offset = page.positive? ? (page - 1) * limit : 0
        @posts = Post.order(created_at: :desc).limit(limit).offset(offset)
        render json: @posts
      end

      def create
        @post = current_user.posts.build(post_params)

        if @post.save
          render json: @post, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @post.user_id == current_user.id
          @post.destroy
          head :no_content, status: :ok
        else
          render json: { error: 'You can only delete your own posts' }, status: :forbidden
        end
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:content)
      end
    end
  end
end
