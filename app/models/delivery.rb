# frozen_string_literal: true

class Delivery < ApplicationRecord
  belongs_to :message

  enum :status, { pending: "pending", sent: "sent", failed: "failed" }

  validates :recipient_email, presence: true
  validates :status, presence: true
end
