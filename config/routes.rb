# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: %i[index show create update] do
        resource :skills, only: %i[show update]
      end
      resource :avatars, only: [:update]
    end
  end
end
