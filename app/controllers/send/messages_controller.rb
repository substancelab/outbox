# frozen_string_literal: true

module Send
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_with_http_basic_if_configured
    before_action :authenticate_api_key

    def create
      message = @authenticated_workspace.messages.find_by(:slug => params[:template_id])
      return render_error("Message not found") unless message

      recipients = Array(params.dig(:via, :email, :to)).compact_blank
      return render_error("No recipients provided") if recipients.empty?

      deliveries = enqueue_deliveries(message, recipients)
      render(:json => {:delivery_ids => deliveries.map(&:id)}, :status => :created)
    end

    private

    def enqueue_deliveries(message, recipients)
      recipients.map { |email| enqueue_delivery(message, email) }
    end

    def enqueue_delivery(message, email)
      delivery = Delivery.create!(delivery_attributes(message, email))
      DeliverEmailJob.perform_later(delivery.id)
      delivery
    end

    def delivery_attributes(message, email)
      email_params = params.dig(:via, :email) || {}
      base_attributes(message, email).merge(email_override_attributes(email_params))
    end

    def base_attributes(message, email)
      {
        :message => message,
        :recipient_email => email,
        :status => :pending,
        :variables => params[:variables]&.to_unsafe_h,
        :variant => params[:variant],
        :workspace => message.workspace,
      }
    end

    def email_override_attributes(email_params)
      {
        :cc => Array(email_params[:cc]).compact_blank.presence,
        :bcc => Array(email_params[:bcc]).compact_blank.presence,
        :from_email => email_params[:from].presence,
        :subject_override => email_params[:subject].presence,
      }
    end

    def authenticate_api_key
      provided_key = request.headers["Authorization"]&.delete_prefix("Bearer ")
      api_key = ApiKey.authenticate(provided_key)
      if api_key
        @authenticated_workspace = api_key.workspace
      else
        render(:json => {:error => "Unauthorized"}, :status => :unauthorized)
      end
    end

    def render_error(text)
      render(:json => {:error => text}, :status => :unprocessable_content)
    end
  end
end
