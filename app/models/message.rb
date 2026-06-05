# frozen_string_literal: true

class Message < ApplicationRecord
  has_many :deliveries, :dependent => :destroy
  has_many :message_variants, :dependent => :destroy

  validates :slug, :presence => true, :uniqueness => true
  validates :subject, :html_body, :text_body, :presence => true
end
