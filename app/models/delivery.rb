# frozen_string_literal: true

class Delivery < ApplicationRecord
  belongs_to :message
  belongs_to :workspace

  enum :status, {:failed => "failed", :pending => "pending", :sent => "sent"}

  serialize :variables, :coder => JSON
  serialize :cc, :coder => JSON
  serialize :bcc, :coder => JSON

  validates :recipient_email, :presence => true
  validates :status, :presence => true
end
