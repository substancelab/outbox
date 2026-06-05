# frozen_string_literal: true

class MessageRenderer
  Result = Data.define(:subject, :html_body, :text_body)

  def self.render(message, variables = {})
    new(message, variables).render
  end

  def initialize(message, variables = {})
    @message = message
    @variables = variables.stringify_keys
  end

  def render
    Result.new(
      :subject => render_field(@message.subject),
      :html_body => render_field(@message.html_body),
      :text_body => render_field(@message.text_body)
    )
  end

  private

  def render_field(template_string)
    Liquid::Template.parse(template_string).render(@variables)
  end
end
