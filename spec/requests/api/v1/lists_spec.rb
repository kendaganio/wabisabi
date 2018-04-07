require 'rails_helper'

describe '/api/v1/lists', type: :api do
  let(:user) { create(:user) }
  let(:new_list) { 'lel' }

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'GET /' do
      before do
        get '/api/v1/lists'
      end

      it 'responds with 200 - ok' do
        expect(last_response.status).to eq(200)
      end

      it 'has correct items'
    end

    describe 'POST /' do
      context 'complete params' do
        before do
          post '/api/v1/lists', new_list
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end
        it 'has correct payload'
        it 'belongs to current user'
      end

      context 'incomplete params' do
        it 'responds with 422 - unprocessable entity'
        it 'has error in the payload'
      end
    end

    describe 'GET /:id' do
      context 'hit' do
        before do
          get '/api/v1/lists/1'
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload'
      end

      context 'miss' do
        it 'responds with 404 - not found'
        it 'has correct message'
      end
    end

    describe 'DELETE /:id' do
      context 'hit' do
        before do
          delete '/api/v1/lists/1'
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload'
        it 'deletes successfully'
      end

      context 'miss' do
        it 'responds with 404 - not found'
        it 'has correct error message'
      end
    end

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
