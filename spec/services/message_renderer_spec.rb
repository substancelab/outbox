# frozen_string_literal: true

require "rails_helper"

RSpec.describe MessageRenderer, :type => :service do
  subject(:renderer) { described_class.new(message, variables) }

  let(:message) do
    build_stubbed(
      :message,
      :html_body => "<p>Hi {{ name }}, your order {{ order_id }} is ready.</p>",
      :subject => "Hello, {{ name }}!",
      :text_body => "Hi {{ name }}, your order {{ order_id }} is ready."
    )
  end
  let(:variables) { {"name" => "Alice", "order_id" => "123"} }

  describe "#render" do
    subject(:result) { renderer.render }

    it "renders the subject" do
      expect(result.subject).to eq("Hello, Alice!")
    end

    it "renders the HTML body" do
      expect(result.html_body).to eq("<p>Hi Alice, your order 123 is ready.</p>")
    end

    it "renders the plain-text body" do
      expect(result.text_body).to eq("Hi Alice, your order 123 is ready.")
    end

    context "when variables are symbols" do
      let(:variables) { {:name => "Bob", :order_id => "456"} }

      it "renders the subject" do
        expect(result.subject).to eq("Hello, Bob!")
      end
    end

    context "when a variable is missing" do
      let(:variables) { {"name" => "Alice"} }

      it "substitutes missing variables with empty string" do
        expect(result.text_body).to eq("Hi Alice, your order  is ready.")
      end
    end

    context "when variables hash is empty" do
      let(:variables) { {} }

      it "leaves all placeholders blank" do
        expect(result.subject).to eq("Hello, !")
      end
    end
  end

  describe ".render" do
    it "is a convenience wrapper returning the same result as #render" do
      result = described_class.render(message, variables)
      expect(result.subject).to eq("Hello, Alice!")
    end
  end
end
