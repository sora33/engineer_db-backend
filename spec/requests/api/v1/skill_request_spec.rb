# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Skills' do
  let(:user) { create(:user) }
  let(:skill) { create(:skill, user:) }
  let(:valid_params) { { skills: [{ name: 'New Skill', level: 5 }] } }
  let(:invalid_params) { { skills: [{ name: '', level: 5 }] } }

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

  describe 'GET /show' do
    subject(:get_show) { get api_v1_user_skills_path(user) }

    it_behaves_like 'returns http status', :success
  end

  describe 'PATCH /update' do
    context 'with valid params' do
      subject(:patch_update) { patch api_v1_user_skills_path(user), params: valid_params }

      it_behaves_like 'returns http status', :success
    end

    context 'with invalid params' do
      subject(:patch_update_with_invalid_params) { patch api_v1_user_skills_path(user), params: invalid_params }

      it_behaves_like 'returns http status', :unprocessable_entity
    end
  end
end
