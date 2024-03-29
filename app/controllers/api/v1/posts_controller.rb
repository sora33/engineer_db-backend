# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: %i[destroy]

      def index
        @posts = paginate(Post.includes(:user, user: :avatar_attachment).order(created_at: :desc))
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
        if @post.user != current_user
          return render json: { error: 'You can only delete your own post.' }, status: :forbidden
        end

        @post.destroy
        head :no_content, status: :ok
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
