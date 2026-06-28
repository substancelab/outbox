# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /workspaces/:workspace_id/deliveries/:delivery_id/retry", :type => :request do
  let(:delivery) {
    create(:delivery, :workspace => workspace, :status => "failed", :error_message => "Something went wrong")
  }
  let(:workspace) { create(:workspace) }

  describe "retrying a failed delivery" do
    before { post workspace_delivery_retry_path(workspace, delivery) }

    it { expect(response).to redirect_to(workspace_deliveries_path(workspace)) }

    it "resets the delivery to pending" do
      expect(delivery.reload).to have_attributes(:status => "pending", :error_message => nil)
    end

    it "enqueues a DeliverEmailJob" do
      expect(DeliverEmailJob).to have_been_enqueued.with(delivery.id)
    end
  end

  describe "retrying a delivery from another workspace" do
    let(:other_delivery) { create(:delivery, :workspace => other_workspace, :status => "failed") }
    let(:other_workspace) { create(:workspace) }

    before { post workspace_delivery_retry_path(workspace, other_delivery) }

    it { expect(response).to have_http_status(:not_found) }
  end
end
