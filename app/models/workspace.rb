# frozen_string_literal: true

class Workspace < ApplicationRecord
  has_many :api_keys, :dependent => :destroy
  has_many :deliveries, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :providers, :dependent => :destroy

  validates :name, :presence => true
end
