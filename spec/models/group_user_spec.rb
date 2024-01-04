# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupUser do
  subject(:group_user) { build(:group_user) }

  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      create(:group_user, user:, group:)
    end

    it 'validates uniqueness of group_id scoped to user_id' do
      new_group_user = build(:group_user, user:, group:)
      expect(new_group_user).not_to be_valid
      expect(new_group_user.errors[:group_id]).to include('has already been taken')
    end
  end
end
