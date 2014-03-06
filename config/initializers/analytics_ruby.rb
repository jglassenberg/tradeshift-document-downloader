class Analytics
  def self.track_event(who, event_name, props={})
    # TODO: add universal traits to the identify call

    identify who, event_name, props

    track event_name, props
  end

  private
  def self.track event_name, props
    # Track to each service
  end

  def self.identify who, event_name, props
    # Identify to each service

    # SendWithUs
    swu = SendWithUs::Api.new( api_key: Rails.application.config.swu_api_key, debug: !Rails.env.production? )
    swu_emails = JSON.parse swu.emails.body

    email = swu_emails.find do |email|
      email['name'] == event_name
    end

    swu_email_id = email['id']
    # swu_email_id = {
    #   'trigger_message_you_won'               => 123,
    #   'trigger_message_invited_to_play'       => 123,
    #   'trigger_message_new_chat_received'     => 123,
    #   'trigger_message_last_answer_recieved'  => 123,
    #   'trigger_message_new_question'          => 123,
    #   'trigger_message_answer_rejected'       => 123
    # }[event_name]

    swu.send_with(
      swu_email_id,
      { address: who.email,
        name: who.name
      },
      props,
      {
        #reply_to:
      }
    )

  end
end
