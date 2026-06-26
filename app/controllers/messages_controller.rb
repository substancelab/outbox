# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message

  def edit; end

  def index
    @messages = current_workspace.messages.order(:slug)
  end

  def show
    redirect_to edit_workspace_message_path(current_workspace, @message)
  end

  def update
    if @message.update(message_params)
      redirect_to edit_workspace_message_path(current_workspace, @message), :notice => t(".success")
    else
      render :edit, :status => :unprocessable_content
    end
  end

  private

  def set_message
    @message = current_workspace.messages.find(params.expect(:id)) if params[:id]
  end

  def message_params
    params.expect(:message => [:subject, :html_body, :text_body, :sender])
  end
end
