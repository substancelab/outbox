# frozen_string_literal: true

module Deliveries
  class RetriesController < ApplicationController
    def create
      delivery = current_workspace.deliveries.find(params.expect(:delivery_id))
      delivery.update!(:status => :pending, :error_message => nil)
      DeliverEmailJob.perform_later(delivery.id)
      redirect_to workspace_deliveries_path(current_workspace), :notice => translate(".success")
    end
  end
end
