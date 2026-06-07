# frozen_string_literal: true

class MailgunAdapter
  def initialize(api_key:, sending_domain:)
    @api_key = api_key
    @sending_domain = sending_domain
  end

  def deliver(params)
    mb = build_message(params)
    response = Mailgun::Client.new(@api_key).send_message(@sending_domain, mb)
    response.to_h.fetch("id")
  end

  private

  def build_message(params)
    mb = Mailgun::MessageBuilder.new
    mb.from(params[:from])
    add_recipients(mb, params)
    mb.subject(params[:subject])
    mb.body_html(params[:html_body])
    mb.body_text(params[:text_body])
    mb
  end

  def add_recipients(builder, params)
    builder.add_recipient(:to, params[:to])
    Array(params[:cc]).compact_blank.each { |addr| builder.add_recipient(:cc, addr) }
    Array(params[:bcc]).compact_blank.each { |addr| builder.add_recipient(:bcc, addr) }
  end
end
