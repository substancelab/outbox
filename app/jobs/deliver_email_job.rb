# frozen_string_literal: true

class DeliverEmailJob < ApplicationJob
  queue_as :default

  def perform(delivery_id)
    delivery = Delivery.find(delivery_id)
    message_id = send_email(delivery)
    delivery.update!(:status => :sent, :email_message_id => message_id, :sent_at => Time.current)
  rescue StandardError => error
    delivery&.update!(:status => :failed, :error_message => error.message)
  end

  private

  def send_email(delivery)
    message = delivery.message
    provider = Provider.sole
    rendered = MessageRenderer.render(message, delivery.variables || {})
    sender = message.sender.presence || provider.sender
    build_adapter(provider).deliver(
      :to => delivery.recipient_email, :from => sender,
      :subject => rendered.subject,
      :html_body => rendered.html_body,
      :text_body => rendered.text_body
    )
  end

  def build_adapter(provider)
    MailgunAdapter.new(:api_key => provider.api_key, :sending_domain => provider.sending_domain)
  end
end
