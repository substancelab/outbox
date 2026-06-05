# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailgunAdapter do
  let(:api_key) { "key-test123" }
  let(:sending_domain) { "mg.example.com" }
  let(:adapter) { described_class.new(:api_key => api_key, :sending_domain => sending_domain) }

  let(:mailgun_url) { "https://api.mailgun.net/v3/#{sending_domain}/messages" }

  let(:deliver_params) do
    {
      :to => "alice@example.com",
      :from => "noreply@example.com",
      :subject => "Hello, Alice!",
      :html_body => "<p>Hi Alice</p>",
      :text_body => "Hi Alice",
    }
  end

  describe "#deliver" do
    context "when Mailgun accepts the message" do
      before do
        stub_request(:post, mailgun_url).
          to_return(
            :status => 200,
            :body => '{"id": "<abc123@mg.example.com>", "message": "Queued. Thank you."}',
            :headers => {"Content-Type" => "application/json"}
          )
      end

      it "returns the Mailgun message id" do
        result = adapter.deliver(**deliver_params)
        expect(result).to eq("<abc123@mg.example.com>")
      end

      it "posts to the correct domain endpoint" do
        adapter.deliver(**deliver_params)
        expect(WebMock).to have_requested(:post, mailgun_url)
      end
    end

    context "when Mailgun rejects with 401 Unauthorized" do
      before do
        stub_request(:post, mailgun_url).
          to_return(
            :status => 401,
            :body => '{"message": "Forbidden"}',
            :headers => {"Content-Type" => "application/json"}
          )
      end

      it "raises a Mailgun::Unauthorized error" do
        expect { adapter.deliver(**deliver_params) }.to raise_error(Mailgun::Unauthorized)
      end
    end

    context "when Mailgun rejects with 400 Bad Request" do
      before do
        stub_request(:post, mailgun_url).
          to_return(
            :status => 400,
            :body => '{"message": "Invalid recipient"}',
            :headers => {"Content-Type" => "application/json"}
          )
      end

      it "raises a Mailgun::BadRequest error" do
        expect { adapter.deliver(**deliver_params) }.to raise_error(Mailgun::BadRequest)
      end
    end
  end
end
