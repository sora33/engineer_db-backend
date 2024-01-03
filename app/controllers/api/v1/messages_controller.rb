# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_group, only: [:index, :create]

      def index
        messages = @group.messages || []
        other_user = @user
        render json: { messages: ActiveModelSerializers::SerializableResource.new(messages), otherUser: ActiveModelSerializers::SerializableResource.new(other_user) }
      end

      def create
        message = @group.messages.build(message_params.merge(user: current_user))

        if message.save
          render json: message, status: :created
        else
          render json: message.errors, status: :unprocessable_entity
        end
      end

      private
      def set_group
        @user = User.find(params[:user_id])
        group_ids = GroupUser.where(user_id: current_user.id).pluck(:group_id)
        group_user = GroupUser.find_by(group_id: group_ids, user_id: @user.id)
      
        unless group_user
          group = Group.create
          GroupUser.create(group: group, user: current_user)
          group_user = GroupUser.create(group: group, user: @user)
        end
      
        @group = group_user.group
      end

      def message_params
        params.permit(:content)
      end
    end
  end
end