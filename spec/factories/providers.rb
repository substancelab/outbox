# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    api_key { "test-api-key" }
    provider { "mailgun" }
    sender { "Outbox <outbox@example.com>" }
    sending_domain { "mg.example.com" }
    workspace
  end
end
