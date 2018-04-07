require 'rails_helper'

describe '/api/v1/tasks', type: :api do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let(:new_task) do
    { 'description' => 'new task' }
  end

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'GET /' do
      let!(:task_list) { create_list(:task, 2, description: 'task', user: user, list: list) }

      before do
        get '/api/v1/tasks'
      end

      it 'responds with 200 - ok' do
        expect(last_response.status).to eq(200)
      end

      it 'has correct items' do
        expect(json['data'].length).to eq(task_list.length)
      end
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
          expect(json['data']['attributes']).to include(
            'description' => new_task['description']
          ).and(include('created_at', 'updated_at'))
        end

        it 'belongs to current_user' do
          expect(user.tasks.count).to eq(1)
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
      let(:task) { create :task, user: user, list: list }

      context 'hit' do
        before do
          get "/api/v1/tasks/#{task.id}"
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['data']['attributes']).to include(
            'description' => task.description,
            'status' => task.status
          ).and(include('created_at', 'updated_at'))
        end
      end

      context 'miss' do
        before do
          get 'api/v1/tasks/999999'
        end

        it 'responds with 404 - not found' do
          expect(last_response.status).to eq(404)
        end

        it 'has correct message' do
          expect(json['errors']).to include(I18n.t('api.not_found'))
        end
      end
    end

    describe 'DELETE /:id' do
      let(:task) { create :task, user: user, list: list }

      context 'hit' do
        before do
          delete "api/v1/tasks/#{task.id}"
        end

        it 'responds with 200 - ok' do
          expect(last_response.status).to eq(200)
        end

        it 'has correct payload' do
          expect(json['data']['attributes']).to include(
            'description' => task.description,
            'status' => task.status
          ).and(include('created_at', 'updated_at'))
        end

        it 'deletes successfully' do
          expect(user.tasks.count).to eq(0)
        end
      end

      context 'miss' do
        before do
          delete 'api/v1/tasks/99999'
        end

        it 'responds with 404 - not found' do
          expect(last_response.status).to eq(404)
        end

        it 'has correct message' do
          expect(json['errors']).to include(I18n.t('api.not_found'))
        end
      end
    end
  end

  context 'unauthenticated user' do
    describe 'GET /' do
      it 'responds with 401 - unauthorized' do
        get '/api/v1/tasks', new_task
        expect(last_response.status).to eq(401)
      end
    end

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

    describe 'DELETE /:id' do
      it 'responds with 401 - unauthorized' do
        delete '/api/v1/tasks/1'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
