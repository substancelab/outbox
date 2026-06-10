# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message

  def edit; end

  def index
    @messages = Message.order(:slug)
  end

  def show
    redirect_to edit_message_path(@message)
  end

  def update
    if @message.update(message_params)
      redirect_to edit_message_path(@message), :notice => t(".success")
    else
      render :edit, :status => :unprocessable_content
    end
  end

  private

  def set_message
    @message = Message.find(params.expect(:id)) if params[:id]
  end

  def message_params
    params.expect(:message => [:subject, :html_body, :text_body, :sender])
  end
end
