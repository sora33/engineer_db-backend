# frozen_string_literal: true

class User < ApplicationRecord
  has_many :skills, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_one_attached :avatar
end
