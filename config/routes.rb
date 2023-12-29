# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: %i[index show create update destroy] do
        resource :skills, only: %i[show update]
      end
      resource :avatars, only: [:update]
      resources :posts, only: %i[index create destroy]
    end
  end
end
