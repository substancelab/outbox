# frozen_string_literal: true

require "rails_helper"

RSpec.describe Workspace, :type => :model do
  subject(:workspace) { build_stubbed(:workspace) }

  it { is_expected.to have_many(:messages).dependent(:destroy) }
  it { is_expected.to have_many(:deliveries).dependent(:destroy) }
  it { is_expected.to have_many(:providers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
end
