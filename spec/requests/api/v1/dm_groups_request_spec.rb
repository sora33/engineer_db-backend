# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::DmGroups' do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:other_user) { create(:user) }

  before do
    create(:group_user, user:, group:)
    create(:group_user, user: other_user, group:)
    create(:message, user: other_user, group:, content: 'Test message')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:authenticate_request).and_return(true)
  end

  describe 'GET /index' do
    subject(:get_index) { get api_v1_dm_groups_path }

    it 'returns http success' do
      get_index
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct response body' do
      get_index
      json = JSON.parse(response.body)
      expect(json).to be_an_instance_of(Array)
      expect(json.first).to include('id', 'name', 'latestMessage')
    end
  end
end

