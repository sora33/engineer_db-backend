# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Messages' do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:other_user) { create(:user) }
  let(:valid_params) { { content: 'Test content' } }
  let(:invalid_params) { { content: '' } }

  before do
    create(:group_user, user:, group:)
    create(:group_user, user: other_user, group:)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return(true)
  end

  describe 'GET /index' do
    subject(:get_index) { get api_v1_user_messages_path(user_id: other_user.id) }

    it 'returns http success' do
      get_index
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct response body' do
      get_index
      json = JSON.parse(response.body)
      expect(json.keys).to match_array(%w[messages otherUser])
    end
  end

  describe 'POST /create' do
    subject(:post_create) { post(api_v1_user_messages_path(user_id: other_user.id), params: valid_params) }

    it 'returns http created' do
      post_create
      expect(response).to have_http_status(:created)
    end

    it 'creates a new message' do
      expect { post_create }.to change(Message, :count).by(1)
    end

    context 'with invalid params' do
      subject(:post_create_with_invalid_params) do
        post(api_v1_user_messages_path(user_id: other_user.id), params: invalid_params)
      end

      it 'returns http unprocessable_entity' do
        post_create_with_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct error message' do
        post_create_with_invalid_params
        json = JSON.parse(response.body)
        expect(json['content']).to include("can't be blank")
      end
    end
  end
end
