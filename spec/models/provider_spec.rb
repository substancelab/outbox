# frozen_string_literal: true

require "rails_helper"

RSpec.describe Provider, type: :model do
  subject(:provider) { build_stubbed(:provider) }

  it { is_expected.to validate_presence_of(:provider) }
  it { is_expected.to validate_presence_of(:api_key) }
  it { is_expected.to validate_presence_of(:sending_domain) }
  it { is_expected.to validate_presence_of(:sender) }
end
