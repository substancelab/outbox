# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    provider { "mailgun" }
    api_key { "test-api-key" }
    sending_domain { "mg.example.com" }
    sender { "Outbox <outbox@example.com>" }
  end
end
