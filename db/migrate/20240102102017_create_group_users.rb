# frozen_string_literal: true

class CreateGroupUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :group_users, id: :uuid do |t|
      t.references :group, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :group_users, %i[user_id group_id], unique: true
  end
end
