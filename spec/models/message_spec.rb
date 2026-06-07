# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, :type => :model do
  subject(:message) { build_stubbed(:message) }

  it { is_expected.to have_many(:message_variants).dependent(:destroy) }
  it { is_expected.to have_many(:deliveries).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:slug) }
  it { expect(create(:message)).to validate_uniqueness_of(:slug) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to validate_presence_of(:html_body) }
  it { is_expected.to validate_presence_of(:text_body) }

  describe "#resolve_variant" do
    subject(:message) { create(:message) }

    context "when a matching variant exists" do
      let!(:variant) { create(:message_variant, :message => message, :variant => "da") }

      it "returns the matching MessageVariant" do
        expect(message.resolve_variant("da")).to eq(variant)
      end
    end

    context "when no matching variant exists" do
      it "returns the base message" do
        expect(message.resolve_variant("unknown")).to eq(message)
      end
    end

    context "when the key is blank" do
      it "returns the base message" do
        expect(message.resolve_variant(nil)).to eq(message)
      end
    end
  end
end
