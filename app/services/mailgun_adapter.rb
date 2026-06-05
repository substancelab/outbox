# frozen_string_literal: true

class MailgunAdapter
  def initialize(api_key:, sending_domain:)
    @api_key = api_key
    @sending_domain = sending_domain
  end

  def deliver(to:, from:, subject:, html_body:, text_body:)
    mb = Mailgun::MessageBuilder.new
    mb.from(from)
    mb.add_recipient(:to, to)
    mb.subject(subject)
    mb.body_html(html_body)
    mb.body_text(text_body)

    response = Mailgun::Client.new(@api_key).send_message(@sending_domain, mb)
    response.to_h.fetch("id")
  end
end
