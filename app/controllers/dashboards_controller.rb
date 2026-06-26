# frozen_string_literal: true

class DashboardsController < ApplicationController
  def show
    redirect_to workspace_messages_path(current_workspace)
  end
end
