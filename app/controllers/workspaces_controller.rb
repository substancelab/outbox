# frozen_string_literal: true

class WorkspacesController < ApplicationController
  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      redirect_to workspace_messages_path(@workspace), :notice => t(".success")
    else
      render :new, :status => :unprocessable_content
    end
  end

  def new
    @workspace = Workspace.new
  end

  private

  def workspace_params
    params.expect(:workspace => [:name, :description])
  end
end
