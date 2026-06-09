# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeliverEmailJob, :type => :job do
  let!(:provider) { create(:provider, :workspace => workspace, :sender => "default@example.com") }
  let!(:workspace) { create(:workspace) }
  let(:delivery) { create(:delivery, :message => message, :variables => {"name" => "Alice"}) }
  let(:message) { create(:message, :workspace => workspace, :sender => nil) }

  let(:adapter_double) { instance_double(MailgunAdapter, :deliver => "<msg@mg.example.com>") }

  before do
    allow(MailgunAdapter).to receive(:new).and_return(adapter_double)
  end

  describe "#perform" do
    it "marks the delivery as sent" do
      described_class.perform_now(delivery.id)

      delivery.reload
      expect(delivery.status).to eq("sent")
    end

    it "stores the Mailgun message id" do
      described_class.perform_now(delivery.id)

      expect(delivery.reload.email_message_id).to eq("<msg@mg.example.com>")
    end

    it "records sent_at" do
      described_class.perform_now(delivery.id)

      expect(delivery.reload.sent_at).not_to be_nil
    end

    it "passes variables from the delivery to the renderer" do
      allow(MessageRenderer).to receive(:render).and_call_original

      described_class.perform_now(delivery.id)

      expect(MessageRenderer).to have_received(:render).with(message, {"name" => "Alice"})
    end

    context "when a matching variant exists" do
      let(:delivery) { create(:delivery, :message => message, :variant => "da", :variables => {}) }

      before { create(:message_variant, :message => message, :variant => "da") }

      it "renders the variant content" do
        allow(MessageRenderer).to receive(:render).and_call_original

        described_class.perform_now(delivery.id)

        expect(MessageRenderer).to have_received(:render).with(be_a(MessageVariant), {})
      end
    end

    context "when the variant key does not match any variant" do
      let(:delivery) { create(:delivery, :message => message, :variant => "unknown", :variables => {}) }

      it "renders the base message content" do
        allow(MessageRenderer).to receive(:render).and_call_original

        described_class.perform_now(delivery.id)

        expect(MessageRenderer).to have_received(:render).with(message, {})
      end
    end

    it "uses message sender when set" do
      message.update!(:sender => "custom@example.com")

      described_class.perform_now(delivery.id)

      expect(adapter_double).to have_received(:deliver).with(hash_including(:from => "custom@example.com"))
    end

    it "falls back to provider sender when message has no sender" do
      described_class.perform_now(delivery.id)

      expect(adapter_double).to have_received(:deliver).with(hash_including(:from => "default@example.com"))
    end

    it "initialises the adapter with provider credentials" do
      described_class.perform_now(delivery.id)

      expect(MailgunAdapter).to have_received(:new).with(
        :api_key => provider.api_key,
        :sending_domain => provider.sending_domain
      )
    end

    context "when the adapter raises" do
      before do
        allow(adapter_double).to receive(:deliver).and_raise(StandardError, "something went wrong")
      end

      it "marks the delivery as failed" do
        described_class.perform_now(delivery.id)

        expect(delivery.reload.status).to eq("failed")
      end

      it "stores the error message" do
        described_class.perform_now(delivery.id)

        expect(delivery.reload.error_message).to eq("something went wrong")
      end
    end
  end
end
