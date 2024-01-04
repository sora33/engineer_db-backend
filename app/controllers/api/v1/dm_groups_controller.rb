# frozen_string_literal: true

module Api
  module V1
    class DmGroupsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      # rubocop:disable Metrics/AbcSize
      def index
        groups = current_user.groups.preload(:users)
        latest_messages = fetch_latest_messages(groups)

        users_with_latest_message = groups.map do |group|
          user = group.users.find { |u| u.id != current_user.id }
          latest_message = latest_messages.find { |message| message.group_id == group.id }
          if latest_message
            user.attributes.merge(latestMessage: ActiveModelSerializers::SerializableResource.new(latest_message))
          end
        end.compact

        render json: users_with_latest_message
      end
      # rubocop:enable Metrics/AbcSize

      private

      def fetch_latest_messages(groups)
        Message.select('DISTINCT ON (group_id) *')
               .where(group_id: groups.ids)
               .order('group_id, created_at DESC')
      end
    end
  end
end
