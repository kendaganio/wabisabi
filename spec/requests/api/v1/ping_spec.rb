require 'rails_helper'

describe '/api/v1/ping', type: :api do
  let(:test_user) { create(:test_user) }

  describe 'GET /' do
    context 'unauthenticated user' do
      before do
        get '/api/v1/ping'
      end

      it 'responds with 401 - unauthorized' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'invalid jwt' do
      before do
        payload = { user_id: test_user.id }
        token = Auth::JWTEncode.call(payload)
        token = token.slice(1, token.length)

        header 'Authorization', "Bearer #{token}"
        get '/api/v1/ping'
      end

      it 'responds with 401 - unauthorized' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'authenticated user' do
      before do
        payload = { user_id: test_user.id }
        token = Auth::JWTEncode.call(payload)

        header 'Authorization', "Bearer #{token}"
        get '/api/v1/ping'
      end

      it 'responds with 200 - ok' do
        expect(last_response.status).to eq(200)
      end

      it 'has correct payload' do
        expect(json['pong']).to eq('pong')
      end
    end
  end
end
