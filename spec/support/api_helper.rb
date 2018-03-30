require 'rack/test'

module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :api
end
