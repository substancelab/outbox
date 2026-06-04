# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  subject(:message) { build_stubbed(:message) }

  it { is_expected.to have_many(:message_variants).dependent(:destroy) }
  it { is_expected.to have_many(:deliveries).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:slug) }
  it { expect(create(:message)).to validate_uniqueness_of(:slug) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:html_body) }
  it { is_expected.to validate_presence_of(:text_body) }
end
