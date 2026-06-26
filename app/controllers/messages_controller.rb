# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message, :only => [:edit, :show, :update]

  def create
    @message = current_workspace.messages.new(message_params)
    if @message.save
      redirect_to edit_workspace_message_path(current_workspace, @message), :notice => t(".success")
    else
      render :new, :status => :unprocessable_content
    end
  end

  def edit; end

  def index
    @messages = current_workspace.messages.order(:slug)
  end

  def new
    @message = current_workspace.messages.new
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
    @message = current_workspace.messages.find(params.expect(:id))
  end

  def message_params
    params.expect(:message => [:slug, :subject, :html_body, :text_body, :sender])
  end
end
