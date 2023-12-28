# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :level, null: false
      t.timestamps
    end
    add_index :skills, %i[name user_id], unique: true
  end
end
