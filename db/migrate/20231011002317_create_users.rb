# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string 'provider', null: false
      t.string 'provider_id', null: false
      t.string 'name', null: false
      t.string 'purpose'
      t.string 'comment'
      t.string 'work'
      t.string 'occupation'
      t.string 'gender'
      t.integer 'experience'
      t.text 'introduction'
      t.text 'hobby'
      t.datetime 'birthday'
      t.string 'location'
      t.string 'website'
      t.datetime 'last_sign_in_at'
      t.timestamps
    end
  end
end
