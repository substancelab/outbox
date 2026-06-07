# frozen_string_literal: true

FactoryBot.define do
  factory :delivery do
    email_message_id { nil }
    error_message { nil }
    message
    recipient_email { "user@example.com" }
    sent_at { nil }
    status { "pending" }
    variant { nil }
  end
end
