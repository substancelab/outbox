# frozen_string_literal: true

require "rails_helper"

RSpec.describe MessageVariant, type: :model do
  subject(:message_variant) { build_stubbed(:message_variant) }

  it { is_expected.to belong_to(:message) }

  it { is_expected.to validate_presence_of(:variant) }
  it { expect(create(:message_variant)).to validate_uniqueness_of(:variant).scoped_to(:message_id) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:html_body) }
  it { is_expected.to validate_presence_of(:text_body) }
end
