# frozen_string_literal: true

Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: %i[index show create update destroy] do
        resource :skills, only: %i[show update]
        resources :posts, only: %i[index], controller: 'users/posts'
        resources :messages, only: %i[index create]
      end
      resource :avatars, only: [:update]
      resources :posts, only: %i[index create destroy]
      resources :dashboard, only: [:index]
      resources :dm_groups, only: %i[index]
    end
  end
end
