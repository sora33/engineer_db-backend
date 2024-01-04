# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :content, presence: true, length: { maximum: 400 }
end
