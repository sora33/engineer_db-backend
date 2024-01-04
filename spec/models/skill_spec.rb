# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Skill do
  subject { build(:skill, user:) }

  let(:user) { create(:user) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  it { is_expected.to validate_presence_of(:level) }
  it { is_expected.to validate_numericality_of(:level).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(7) }
  it { is_expected.to validate_numericality_of(:level).only_integer }
end
