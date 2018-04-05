require 'rails_helper'

describe '/api/v1/lists', type: :api do
  let(:new_list) { 'lel' }

  context 'authenticated user' do
  end

  context 'unauthenticated user' do
    describe 'GET /' do
      it 'responds with 401 - unauthorized' do
        get '/api/v1/lists', new_list
        expect(last_response.status).to eq(401)
      end
    end

    describe 'POST /' do
      it 'responds with 401 - unauthorized' do
        post '/api/v1/lists', new_list
        expect(last_response.status).to eq(401)
      end
    end

    describe 'GET /:id' do
      it 'responds with 401 - unauthorized' do
        get '/api/v1/lists/1'
        expect(last_response.status).to eq(401)
      end
    end

    describe 'DELETE /:id' do
      it 'responds with 401 - unauthorized' do
        delete '/api/v1/lists/1'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
