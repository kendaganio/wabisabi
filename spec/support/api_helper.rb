require 'rack/test'

module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json
    JSON.parse(last_response.body)
  end

  def auth_header(user)
    token = Auth::JWTEncode.call(user_id: user.id)
    "Bearer #{token}"
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
end
