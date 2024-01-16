# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :messages, dependent: :destroy

  def mark_messages_as_read_for(user)
    messages.where.not(user_id: user.id).where(is_read: false).update_all(is_read: true) # rubocop:disable Rails/SkipsModelValidations
  end
end
