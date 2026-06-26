# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser :versions => :modern

  before_action :authenticate_with_http_basic_if_configured
  before_action :set_workspaces

  helper_method :current_workspace

  private

  def authenticate_with_http_basic_if_configured
    username = ENV.fetch("HTTP_BASIC_AUTH_USERNAME", nil)
    password = ENV.fetch("HTTP_BASIC_AUTH_PASSWORD", nil)
    return unless username.present? && password.present?

    authenticate_or_request_with_http_basic do |u, p|
      ActiveSupport::SecurityUtils.secure_compare(u, username) &&
        ActiveSupport::SecurityUtils.secure_compare(p, password)
    end
  end

  def current_workspace
    @current_workspace ||= if params[:workspace_id]
      Workspace.find(params.expect(:workspace_id))
    else
      Workspace.first!
    end
  end

  def set_workspaces
    @workspaces = Workspace.order(:name)
  end
end
