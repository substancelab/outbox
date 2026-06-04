# frozen_string_literal: true

require "rails_helper"

RSpec.describe Delivery, type: :model do
  subject(:delivery) { build_stubbed(:delivery) }

  it { is_expected.to belong_to(:message) }

  it { is_expected.to validate_presence_of(:recipient_email) }
  it { is_expected.to validate_presence_of(:status) }

  it { is_expected.to define_enum_for(:status).with_values(pending: "pending", sent: "sent", failed: "failed").backed_by_column_of_type(:string) }
end
