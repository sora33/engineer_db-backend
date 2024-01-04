# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Posts' do
  let(:user) { create(:user) }
  let(:post_item) { create(:post, user:) }
  let(:valid_params) { { post: { content: 'Test content' } } }
  let(:invalid_params) { { post: { content: '' } } }

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
    subject(:get_index) { get api_v1_posts_path }

    it_behaves_like 'returns http status', :success
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:post_create) { post(api_v1_posts_path, params: valid_params) }

      it_behaves_like 'returns http status', :created
    end

    context 'with invalid params' do
      subject(:post_create_with_invalid_params) { post(api_v1_posts_path, params: invalid_params) }

      it_behaves_like 'returns http status', :unprocessable_entity
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_post) { delete api_v1_post_path(post_item) }

    context 'when the user is the owner of the post' do
      let(:post_item) { create(:post, user:) }

      it_behaves_like 'returns http status', :no_content
    end

    context 'when the user is not the owner of the post' do
      let(:post_item) { create(:post, user: create(:user)) }

      it_behaves_like 'returns http status', :forbidden
    end
  end
end
