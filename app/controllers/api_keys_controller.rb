# frozen_string_literal: true

class ApiKeysController < ApplicationController
  before_action :set_api_key, :only => [:destroy, :show]

  def create
    @api_key = current_workspace.api_keys.new(api_key_params)
    if @api_key.save
      session[:new_api_key_plaintext] = @api_key.plaintext_key
      redirect_to workspace_api_key_path(current_workspace, @api_key)
    else
      render :new, :status => :unprocessable_content
    end
  end

  def destroy
    @api_key.destroy!
    redirect_to workspace_api_keys_path(current_workspace), :notice => translate(".success")
  end

  def index
    @api_keys = current_workspace.api_keys.order(:name)
  end

  def new
    @api_key = current_workspace.api_keys.new
  end

  def show
    @plaintext_key = session.delete(:new_api_key_plaintext)
    redirect_to workspace_api_keys_path(current_workspace) unless @plaintext_key
  end

  private

  def api_key_params
    params.expect(:api_key => [:name])
  end

  def set_api_key
    @api_key = current_workspace.api_keys.find(params.expect(:id))
  end
end
