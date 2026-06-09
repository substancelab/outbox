# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :workspace
  has_many :deliveries, :dependent => :destroy
  has_many :message_variants, :dependent => :destroy

  validates :slug, :presence => true, :uniqueness => true
  validates :subject, :html_body, :text_body, :presence => true

  def resolve_variant(key)
    return self if key.blank?

    message_variants.find_by(:variant => key) || self
  end
end
