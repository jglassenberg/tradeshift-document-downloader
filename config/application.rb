require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module TheCatch
  class Application < Rails::Application

    class << self
      attr_accessor :NO_CALLBACKS
    end

    self.NO_CALLBACKS = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = false
    I18n.config.enforce_available_locales = false

    config.secret_key_base = '4fbcbf25fd835902fb5163644ee5ad6b1acb40a3761a39a5995402b9774560eee6a1b42052c974a9913d62bbafa94e735ad5b17aa80705272d10f64d1912670d'

  end
end
