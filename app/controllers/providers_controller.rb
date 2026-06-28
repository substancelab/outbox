# frozen_string_literal: true

class ProvidersController < ApplicationController
  before_action :set_provider, :only => [:destroy, :edit, :show, :update]

  def create
    @provider = current_workspace.providers.new(provider_params)
    if @provider.save
      redirect_to workspace_providers_path(current_workspace), :notice => t(".success")
    else
      render :new, :status => :unprocessable_content
    end
  end

  def destroy
    @provider.destroy!
    redirect_to workspace_providers_path(current_workspace), :notice => t(".success")
  end

  def edit; end

  def index
    @providers = current_workspace.providers.order(:sender)
  end

  def new
    @provider = current_workspace.providers.new
  end

  def show
    redirect_to edit_workspace_provider_path(current_workspace, @provider)
  end

  def update
    if @provider.update(update_params)
      redirect_to workspace_providers_path(current_workspace), :notice => t(".success")
    else
      render :edit, :status => :unprocessable_content
    end
  end

  private

  def provider_params
    params.expect(:provider => [:provider, :sender, :sending_domain, :api_host, :api_key])
  end

  def update_params
    provider_params.tap do |p|
      p.delete(:api_key) if p[:api_key].blank?
    end
  end

  def set_provider
    @provider = current_workspace.providers.find(params.expect(:id))
  end
end
