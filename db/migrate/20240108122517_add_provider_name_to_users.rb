# frozen_string_literal: true

class AddProviderNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider_name, :string
  end
end
