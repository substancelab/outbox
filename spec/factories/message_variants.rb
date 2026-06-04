# frozen_string_literal: true

FactoryBot.define do
  factory :message_variant do
    association :message
    sequence(:variant) { |n| "variant-#{n}" }
    subject { "Hej, {{ name }}" }
    html_body { "<p>Hej, {{ name }}</p>" }
    text_body { "Hej, {{ name }}" }
  end
end
