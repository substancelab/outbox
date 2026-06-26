# frozen_string_literal: true

class Provider < ApplicationRecord
  TYPES = ["mailgun"].freeze

  belongs_to :workspace

  encrypts :api_key

  validates :provider, :api_key, :sending_domain, :sender, :presence => true
  validates :provider, :inclusion => {:in => TYPES}
end
