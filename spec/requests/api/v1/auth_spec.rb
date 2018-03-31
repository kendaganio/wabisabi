require 'rails_helper'

describe '/api/v1/auth', type: :api do
  describe 'POST /' do
    context 'valid user' do
      before do
        create(:user)
        post '/api/v1/auth', email: 'login@mailinator.com', password: 'loginpass'
      end

      it 'responds with 200 - ok' do
        expect(last_response.status).to eq(200)
      end

      it 'returns token' do
        expect(json['token']).to_not be_nil
      end
    end

    context 'invalid user' do
      before do
        post '/api/v1/auth', email: 'wala@mailinator.com', password: '....'
      end

      it 'responds with 403 - forbidden' do
        expect(last_response.status).to eq(403)
      end

      it 'does not return token' do
        expect(json['token']).to be_nil
      end

      it 'shows error message' do
        expect(json['error']).to eq(I18n.t('auth.invalid_credentials'))
      end
    end
  end
end
