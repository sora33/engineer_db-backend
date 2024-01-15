# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :content, presence: true, length: { maximum: 400 }

  def self.latest_for_groups(group_ids)
    select('DISTINCT ON (group_id) *')
      .where(group_id: group_ids)
      .order('group_id, created_at DESC')
  end
end
