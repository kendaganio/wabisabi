require 'rails_helper'

describe '/api/v1/lists', type: :api do
  let(:user) { create(:user) }
  let(:new_list) do
    { 'name' => 'new list' }
  end

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'GET /' do
      let!(:lists) { create_list(:list, 2, user: user) }

      before do
        get '/api/v1/lists'
      end

      it 'responds with 200 - ok' do
        expect(last_response.status).to eq(200)
      end

      it 'has correct items' do
        expect(json['data'].length).to eq(lists.length)
      end
    end

    describe 'POST /' do
      context 'complete params' do
        before do
          post '/api/v1/lists', new_list
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['data']['attributes']).to include(
            'name' => new_list['name']
          ).and(include('created_at', 'updated_at'))
        end

        it 'belongs to current user' do
          expect(user.lists.count).to eq(1)
        end
      end

      context 'incomplete params' do
        before do
          post '/api/v1/lists', {}
        end

        it 'responds with 422 - unprocessable entity' do
          expect(last_response.status).to eq(422)
        end

        it 'has error in the payload' do
          expect(json.key?('errors')).to be_truthy
        end
      end
    end

    describe 'GET /:id' do
      let(:list) { create(:list, user: user) }

      context 'hit' do
        before do
          get "/api/v1/lists/#{list.id}"
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['data']['attributes']).to include('name' => list.name)
        end
      end

      context 'miss' do
        before do
          get '/api/v1/lists/9999'
        end

        it 'responds with 404 - not found' do
          expect(last_response.status).to eq(404)
        end

        it 'has correct message' do
          expect(json['errors']).to include(/not found/)
        end
      end
    end

    describe 'DELETE /:id' do
      let(:list) { create(:list, user: user) }

      context 'hit' do
        before do
          delete "/api/v1/lists/#{list.id}"
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['data']['attributes']).to include('name' => list.name)
        end

        it 'deletes successfully' do
          expect(user.lists.count).to eq(0)
        end
      end

      context 'miss' do
        before do
          delete 'api/v1/lists/9999'
        end

        it 'responds with 404 - not found' do
          expect(last_response.status).to eq(404)
        end

        it 'has correct error message' do
          expect(json['errors']).to include(/not found/)
        end
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
        post '/api/v1/lists', {}
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
