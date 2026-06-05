# frozen_string_literal: true

class Delivery < ApplicationRecord
  belongs_to :message

  enum :status, {:failed => "failed", :pending => "pending", :sent => "sent"}

  serialize :variables, :coder => JSON

  validates :recipient_email, :presence => true
  validates :status, :presence => true
end
