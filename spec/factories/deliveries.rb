# frozen_string_literal: true

FactoryBot.define do
  factory :delivery do
    message
    recipient_email { "user@example.com" }
    variant { nil }
    email_message_id { nil }
    status { "pending" }
    error_message { nil }
    sent_at { nil }
  end
end
