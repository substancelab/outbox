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
    provider = Provider.sole
    build_adapter(provider).deliver(email_params(delivery, provider))
  end

  def email_params(delivery, provider)
    rendered = render_message(delivery)
    {
      :to => delivery.recipient_email,
      :cc => delivery.cc.presence,
      :bcc => delivery.bcc.presence,
      :from => resolved_sender(delivery, provider),
      :subject => delivery.subject_override.presence || rendered.subject,
      :html_body => rendered.html_body,
      :text_body => rendered.text_body,
    }
  end

  def render_message(delivery)
    message = delivery.message
    MessageRenderer.render(message.resolve_variant(delivery.variant), delivery.variables || {})
  end

  def resolved_sender(delivery, provider)
    delivery.from_email.presence || delivery.message.sender.presence || provider.sender
  end

  def build_adapter(provider)
    MailgunAdapter.new(:api_key => provider.api_key, :sending_domain => provider.sending_domain)
  end
end
