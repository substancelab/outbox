# frozen_string_literal: true

FactoryBot.define do
  factory :message_variant do
    html_body { "<p>Hej, {{ name }}</p>" }
    message
    sequence(:variant) { |n| "variant-#{n}" }
    subject { "Hej, {{ name }}" }
    text_body { "Hej, {{ name }}" }
  end
end
