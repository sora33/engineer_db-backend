# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  describe 'associations' do
    it { is_expected.to have_many(:group_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:group_users) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end
end
