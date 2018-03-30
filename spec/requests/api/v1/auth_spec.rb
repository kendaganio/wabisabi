require 'rails_helper'

describe '/api/v1/auth', type: :api do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /' do
    context 'valid user' do
      before do
        create(:test_user)
        post '/api/v1/auth', { email: 'login@mailinator.com', password: 'loginpass' }
      end

      it 'returns token' do
        expect(json['token']).to_not be_nil
      end

      it 'responds with 200' do
        expect(last_response.status).to eq(200)
      end
    end

    context 'invalid user' do
      before do
        post '/api/v1/auth', { email: 'wala@mailinator.com', password: '....' }
      end

      it 'does not return token' do
        expect(json['token']).to be_nil
      end

      it 'responds with 401' do
        expect(last_response.status).to eq(401)
      end
    end
  end
end
