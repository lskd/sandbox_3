# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|

  # config.secret_key = '08f6ed49851e3da99c57e65b81bfad9a026de6227b4de4f770aef3d4158e8df482771a533bddc9c66deb125f9efa4116ffc60b5896a95b1d267d5214f7d95d20'

  # TODO: Replace Developer's PERSONAL KEYS with ones appropriate for the product.
  config.omniauth :facebook, "KEY", "SECRET"
  config.omniauth :twitter, "KEY", "SECRET"
  config.omniauth :linked_in, "KEY", "SECRET"

  config.mailer_sender = 'someone@tag-app.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..72
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

end
