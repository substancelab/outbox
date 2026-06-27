# frozen_string_literal: true

class DeliveriesController < ApplicationController
  def index
    @deliveries = current_workspace.deliveries.includes(:message).order(:created_at => :desc)
  end
end
