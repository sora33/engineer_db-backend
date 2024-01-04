# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:provider_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:location).is_at_most(25) }
    it { is_expected.to validate_length_of(:purpose).is_at_most(25) }
    it { is_expected.to validate_length_of(:comment).is_at_most(25) }
    it { is_expected.to validate_length_of(:work).is_at_most(25) }
    it { is_expected.to validate_length_of(:occupation).is_at_most(25) }
    it { is_expected.to validate_length_of(:gender).is_at_most(25) }

    it 'validates numericality of experience' do
      expect(user).to validate_numericality_of(:experience)
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it { is_expected.to validate_length_of(:website).is_at_most(200) }
    it { is_expected.to validate_length_of(:hobby).is_at_most(600) }
    it { is_expected.to validate_length_of(:introduction).is_at_most(600) }
  end

  describe '.age_distribution' do
    before do
      create_list(:user, 2, birthday: 25.years.ago)
      create(:user, birthday: 35.years.ago)
    end

    it 'returns a hash with age distribution' do
      expected_result = {
        under_20_years: 0,
        '20_29_years': 2,
        '30_39_years': 1,
        '40_49_years': 0,
        '50_59_years': 0,
        '60_69_years': 0,
        over_70_years: 0
      }

      expect(described_class.age_distribution).to eq(expected_result)
    end
  end

  describe '.purpose_distribution' do
    before do
      create_list(:user, 2, purpose: 'work')
      create(:user, purpose: 'hobby')
    end

    it 'returns a hash with purpose distribution' do
      expected_result = {
        'work' => 2,
        'hobby' => 1,
        'other' => 0,
        'partner' => 0
      }

      expect(described_class.purpose_distribution).to eq(expected_result)
    end
  end

  describe '.occupation_distribution' do
    before do
      create_list(:user, 2, occupation: 'engineer')
      create(:user, occupation: 'projectManager')
    end

    it 'returns a hash with occupation distribution' do
      expected_result = {
        'engineer' => 2,
        'projectManager' => 1,
        'consultant' => 0,
        'dataAnalyst' => 0,
        'cto' => 0,
        'other' => 0
      }

      expect(described_class.occupation_distribution).to eq(expected_result)
    end
  end

  describe '.work_distribution' do
    before do
      create_list(:user, 2, work: 'fullTime')
      create(:user, work: 'freelancer')
    end

    it 'returns a hash with work distribution' do
      expected_result = {
        'fullTime' => 2,
        'freelancer' => 1,
        'businessOwner' => 0,
        'student' => 0,
        'other' => 0
      }

      expect(described_class.work_distribution).to eq(expected_result)
    end
  end
end
