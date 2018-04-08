require 'rails_helper'
require_relative './api_shared_examples'

describe '/api/v1/lists', type: :api do
  let(:user) { create(:user) }
  let(:new_list) { { 'name' => 'new_list' } }

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'GET /' do
      let!(:collection) { create_list(:list, 2, user: user) }

      before do
        get '/api/v1/lists'
      end

      it_behaves_like 'a valid api request'

      it 'has correct items' do
        expect(json['data'].length).to eq(collection.length)
      end
    end

    describe 'POST /' do
      context 'complete params' do
        before do
          post '/api/v1/lists', new_list
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { new_list }
        end

        it 'belongs to current user' do
          expect(user.lists.count).to eq(1)
        end
      end

      context 'incomplete params' do
        before do
          post '/api/v1/lists', {}
        end

        it_behaves_like 'an invalid api request'
      end
    end

    describe 'GET /:id' do
      let(:list) { create(:list, user: user) }

      context 'hit' do
        before do
          get "/api/v1/lists/#{list.id}"
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { { 'name' => list.name } }
        end
      end

      context 'miss' do
        before do
          get '/api/v1/lists/9999'
        end

        it_behaves_like 'a resource was not found'
      end
    end

    describe 'DELETE /:id' do
      let(:list) { create(:list, name: 'to delete', user: user) }

      context 'hit' do
        before do
          delete "/api/v1/lists/#{list.id}"
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { { 'name' => 'to delete' } }
        end

        it 'deletes successfully' do
          expect(user.lists.count).to eq(0)
        end
      end

      context 'miss' do
        before do
          delete '/api/v1/lists/9999'
        end

        it_behaves_like 'a resource was not found'
      end
    end
  end

  it_behaves_like 'an unauthenticated endpoint', '/api/v1/lists'
end
