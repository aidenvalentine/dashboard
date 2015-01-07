#config/initalizers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  id = Rails.application.secrets.client_id
  secret = Rails.application.secrets.client_secret
  provider :google_oauth2, id, secret, {
  scope: ['email',
    'https://www.googleapis.com/auth/gmail.modify'],
    access_type: 'offline'}
end