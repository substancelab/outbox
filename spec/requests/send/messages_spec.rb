# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /send/message", :type => :request do
  let(:api_key) { create(:api_key, :workspace => message.workspace).plaintext_key }
  let(:body) do
    {
      "template_id" => message.slug,
      "via" => {
        "email" => {
          "to" => ["alice@example.com"],
        },
      },
      "variables" => {"name" => "Alice"},
    }
  end
  let(:headers) { {"ACCEPT" => "application/json", "Authorization" => "Bearer #{api_key}"} }
  let(:message) { create(:message) }

  describe "authentication" do
    context "when no Authorization header is provided" do
      before { post "/send/message", :headers => {"ACCEPT" => "application/json"}, :params => body, :as => :json }

      it { expect(response).to have_http_status(:unauthorized) }
      it { expect(response.parsed_body["error"]).to eq("Unauthorized") }
    end

    context "when an invalid API key is provided" do
      let(:bad_headers) { headers.merge("Authorization" => "Bearer wrong-key") }

      before { post "/send/message", :headers => bad_headers, :params => body, :as => :json }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe "request validation" do
    context "when template_id does not match any message" do
      let(:body) { super().merge("template_id" => "nonexistent-slug") }

      before { post "/send/message", :headers => headers, :params => body, :as => :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body["error"]).to eq("Message not found") }
    end

    context "when no recipients are provided" do
      let(:body) { super().merge("via" => {"email" => {"to" => []}}) }

      before { post "/send/message", :headers => headers, :params => body, :as => :json }

      it { expect(response).to have_http_status(:unprocessable_content) }
      it { expect(response.parsed_body["error"]).to eq("No recipients provided") }
    end
  end

  describe "successful delivery queuing" do
    before { post "/send/message", :headers => headers, :params => body, :as => :json }

    it { expect(response).to have_http_status(:created) }
    it { expect(response.content_type).to eq("application/json; charset=utf-8") }
    it { expect(response.parsed_body["delivery_ids"]).to be_an(Array) }
    it { expect(response.parsed_body["delivery_ids"].length).to eq(1) }

    it "creates a Delivery record per recipient" do
      delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
      expect(delivery).to have_attributes(
        :message => message,
        :recipient_email => "alice@example.com",
        :status => "pending"
      )
    end

    it "enqueues a DeliverEmailJob per delivery" do
      delivery_id = response.parsed_body["delivery_ids"].first
      expect(DeliverEmailJob).to have_been_enqueued.with(delivery_id)
    end
  end

  describe "multiple recipients" do
    let(:body) do
      super().merge("via" => {"email" => {"to" => ["alice@example.com", "bob@example.com"]}})
    end

    before { post "/send/message", :headers => headers, :params => body, :as => :json }

    it { expect(response).to have_http_status(:created) }
    it { expect(response.parsed_body["delivery_ids"].length).to eq(2) }
    it { expect(Delivery.count).to eq(2) }

    it "enqueues one job per delivery" do
      response.parsed_body["delivery_ids"].each do |id|
        expect(DeliverEmailJob).to have_been_enqueued.with(id)
      end
    end
  end

  describe "email delivery overrides" do
    let(:adapter_double) { instance_double(MailgunAdapter, :deliver => "<msg@mg.example.com>") }

    before do
      create(:provider, :workspace => message.workspace)
      allow(MailgunAdapter).to receive(:new).and_return(adapter_double)
    end

    context "when cc, bcc, from, and subject are provided" do
      let(:body) do
        super().merge(
          "via" => {
            "email" => {
              "to" => ["alice@example.com"],
              "cc" => ["manager@example.com"],
              "bcc" => ["archive@example.com"],
              "from" => "Custom <custom@example.com>",
              "subject" => "Override subject",
            },
          }
        )
      end

      before { post "/send/message", :headers => headers, :params => body, :as => :json }

      it "stores cc on the Delivery" do
        delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
        expect(delivery.cc).to eq(["manager@example.com"])
      end

      it "stores bcc on the Delivery" do
        delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
        expect(delivery.bcc).to eq(["archive@example.com"])
      end

      it "stores from_email on the Delivery" do
        delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
        expect(delivery.from_email).to eq("Custom <custom@example.com>")
      end

      it "stores subject_override on the Delivery" do
        delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
        expect(delivery.subject_override).to eq("Override subject")
      end

      it "passes cc, bcc, from, and subject override to the adapter" do
        DeliverEmailJob.perform_now(response.parsed_body["delivery_ids"].first)
        expect(adapter_double).to have_received(:deliver).with(
          hash_including(
            :cc => ["manager@example.com"],
            :bcc => ["archive@example.com"],
            :from => "Custom <custom@example.com>",
            :subject => "Override subject"
          )
        )
      end
    end

    context "when no overrides are provided" do
      before { post "/send/message", :headers => headers, :params => body, :as => :json }

      it "uses the template subject" do
        DeliverEmailJob.perform_now(response.parsed_body["delivery_ids"].first)
        expect(adapter_double).to have_received(:deliver).with(hash_including(:subject => "Hello, Alice"))
      end
    end
  end

  describe "variant" do
    let(:adapter_double) { instance_double(MailgunAdapter, :deliver => "<msg@mg.example.com>") }

    before do
      create(:provider, :workspace => message.workspace)
      allow(MailgunAdapter).to receive(:new).and_return(adapter_double)
    end

    context "when the variant matches a MessageVariant" do
      before do
        create(:message_variant, :message => message, :variant => "da")
        post "/send/message", :headers => headers, :params => body.merge("variant" => "da"), :as => :json
      end

      it "stores the variant on the Delivery" do
        delivery = Delivery.find(response.parsed_body["delivery_ids"].first)
        expect(delivery.variant).to eq("da")
      end

      it "delivers the variant content when the job runs" do
        delivery_id = response.parsed_body["delivery_ids"].first
        DeliverEmailJob.perform_now(delivery_id)

        expect(adapter_double).to have_received(:deliver).with(hash_including(:subject => "Hej, Alice"))
      end
    end

    context "when the variant does not match any MessageVariant" do
      before do
        post "/send/message", :headers => headers, :params => body.merge("variant" => "unknown"), :as => :json
      end

      it "delivers the base message content when the job runs" do
        delivery_id = response.parsed_body["delivery_ids"].first
        DeliverEmailJob.perform_now(delivery_id)

        expect(adapter_double).to have_received(:deliver).with(hash_including(:subject => "Hello, Alice"))
      end
    end
  end
end
