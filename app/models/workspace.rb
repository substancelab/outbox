# frozen_string_literal: true

class Workspace < ApplicationRecord
  has_many :messages, :dependent => :destroy
  has_many :deliveries, :dependent => :destroy
  has_many :providers, :dependent => :destroy

  validates :name, :presence => true
end
