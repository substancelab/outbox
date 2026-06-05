# frozen_string_literal: true

require "rails_helper"

RSpec.describe Delivery, :type => :model do
  subject(:delivery) { build_stubbed(:delivery) }

  it { is_expected.to belong_to(:message) }

  it { is_expected.to validate_presence_of(:recipient_email) }
  it { is_expected.to validate_presence_of(:status) }

  it "has a status enum with the expected values" do
    expect(subject).to \
      define_enum_for(:status).
      with_values(
        :failed => "failed",
        :pending => "pending",
        :sent => "sent"
      ).backed_by_column_of_type(:string)
  end
end
