# frozen_string_literal: true

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :is_read, :user_id, :created_at, :updated_at
end
