# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    sequence(:slug) { |n| "message-#{n}" }
    subject { "Hello, {{ name }}" }
    html_body { "<p>Hello, {{ name }}</p>" }
    text_body { "Hello, {{ name }}" }
    sender { nil }
  end
end
