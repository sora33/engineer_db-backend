# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Users' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_params) { { user: attributes_for(:user) } }
  let(:invalid_params) { { user: attributes_for(:user, name: nil) } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return(true)
  end

  shared_examples 'returns http status' do |status|
    it "returns http #{status}" do
      subject
      expect(response).to have_http_status(status)
    end
  end

  describe 'GET /index' do
    subject(:get_index) { get api_v1_users_path }

    it_behaves_like 'returns http status', :success
  end

  describe 'GET /show' do
    context 'when user exists' do
      subject(:get_show) { get api_v1_user_path(user) }

      it_behaves_like 'returns http status', :success
    end

    context 'when user does not exist' do
      subject(:get_show_nonexistent) { get api_v1_user_path('nonexistent') }

      it_behaves_like 'returns http status', :not_found
    end

    context 'when authentication fails' do
      subject(:get_show) { get api_v1_user_path(user) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_call_original
      end

      it_behaves_like 'returns http status', :unauthorized
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:post_create) { post api_v1_users_path, params: valid_params }

      it_behaves_like 'returns http status', :success
    end

    context 'with invalid params' do
      subject(:post_create_with_invalid_params) { post api_v1_users_path, params: invalid_params }

      it_behaves_like 'returns http status', :unprocessable_entity
    end
  end

  describe 'PATCH /update' do
    context 'with valid params' do
      subject(:patch_update) { patch api_v1_user_path(user), params: valid_params }

      it_behaves_like 'returns http status', :success
    end

    context 'with invalid params' do
      subject(:patch_update_with_invalid_params) { patch api_v1_user_path(user), params: invalid_params }

      it_behaves_like 'returns http status', :unprocessable_entity
    end

    context 'when a user tries to update another user\'s profile' do
      it 'does not update the profile and returns forbidden status' do
        patch api_v1_user_path(other_user), params: valid_params
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the user is the owner of the account' do
      it 'deletes the user' do
        delete api_v1_user_path(user)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the user is not the owner of the account' do
      it 'does not delete the user and returns forbidden status' do
        delete api_v1_user_path(other_user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
