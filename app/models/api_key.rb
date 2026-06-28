# frozen_string_literal: true

class ApiKey < ApplicationRecord
  belongs_to :workspace

  validates :key_digest, :presence => true
  validates :name, :presence => true

  attr_reader :plaintext_key

  before_validation :generate_key, :on => :create

  def self.authenticate(token)
    return if token.blank?

    digest = Digest::SHA256.hexdigest(token)
    find_by(:key_digest => digest)
  end

  private

  def generate_key
    @plaintext_key = "outbox_#{SecureRandom.hex(32)}"
    self.key_digest = Digest::SHA256.hexdigest(@plaintext_key)
  end
end
