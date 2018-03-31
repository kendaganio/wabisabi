require 'rails_helper'

describe '/api/v1/tasks', type: :api do
  let(:user) { create(:test_user) }
  let(:new_task) do
    {
      'description' => 'new task'
    }
  end

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'POST /' do
      context 'complete params' do
        before do
          post '/api/v1/tasks', new_task
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has the correct payload' do
          expect(json.key?('id')).to be_truthy
        end
      end

      context 'incomplete params' do
        before do
          post 'api/v1/tasks', {}
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
      let(:task) { create :task }

      context 'hit' do
        before do
          get "/api/v1/tasks/#{task.id}"
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['description']).to eq(task.description)
        end
      end

      context 'miss' do
        before do
          get "api/v1/tasks/999999"
        end

        it 'responds with 404 - not found' do
          expect(last_response.status).to eq(404)
        end
      end
    end
  end

  context 'unauthenticated user' do
    describe 'POST /' do
      it 'responds with 401 - unauthorized' do
        post '/api/v1/tasks', new_task
        expect(last_response.status).to eq(401)
      end
    end

    describe 'GET /:id' do
      it 'responds with 401 - unauthorized' do
        get '/api/v1/tasks/1'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
