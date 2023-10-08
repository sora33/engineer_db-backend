# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
