# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApiKey, :type => :model do
  describe "validations" do
    it { is_expected.to belong_to(:workspace) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "key generation" do
    subject(:api_key) { build(:api_key) }

    before { api_key.validate }

    it "generates a plaintext key on create" do
      expect(api_key.plaintext_key).to be_present
    end

    it "prefixes the plaintext key with outbox_" do
      expect(api_key.plaintext_key).to start_with("outbox_")
    end

    it "sets key_digest to the SHA256 of the plaintext key" do
      expect(api_key.key_digest).to eq(Digest::SHA256.hexdigest(api_key.plaintext_key))
    end
  end

  describe ".authenticate" do
    let!(:api_key) { create(:api_key) }
    let(:plaintext) { api_key.plaintext_key }

    it "returns the api_key for a valid token" do
      expect(described_class.authenticate(plaintext)).to eq(api_key)
    end

    it "returns nil for an invalid token" do
      expect(described_class.authenticate("wrong-token")).to be_nil
    end

    it "returns nil for a blank token" do
      expect(described_class.authenticate("")).to be_nil
    end

    it "returns nil for nil" do
      expect(described_class.authenticate(nil)).to be_nil
    end
  end
end
