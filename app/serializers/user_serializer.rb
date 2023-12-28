# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :purpose, :comment, :introduction, :hobby, :birthday, :location, :work, :occupation, :website,
             :avatar, :updated_at, :created_at

  def avatar
    return rails_blob_url(object.avatar, only_path: true) if object.avatar.attached?

    nil
  end
end
