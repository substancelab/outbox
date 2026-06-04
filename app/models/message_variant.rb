# frozen_string_literal: true

class MessageVariant < ApplicationRecord
  belongs_to :message

  validates :variant, presence: true, uniqueness: { scope: :message_id }
  validates :subject, :html_body, :text_body, presence: true
end
