# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    html_body { "<p>Hello, {{ name }}</p>" }
    sender { nil }
    sequence(:slug) { |n| "message-#{n}" }
    subject { "Hello, {{ name }}" }
    text_body { "Hello, {{ name }}" }
  end
end
