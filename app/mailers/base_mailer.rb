class BaseMailer
  class << self
    include Rails.application.routes.url_helpers
  end
  
  protected
  def self.trigger_message(user, mail_name, properties={})
    Analytics.track_event user, "trigger_message_#{mail_name}", properties
  end
end