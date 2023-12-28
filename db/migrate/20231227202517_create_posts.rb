# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
    end
  end
end
