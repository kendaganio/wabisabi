require 'rails_helper'
require_relative './api_shared_examples'

describe '/api/v1/tasks', type: :api do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }
  let(:new_task) { { 'description' => 'new task' } }

  context 'authenticated user' do
    before do
      header 'Authorization', auth_header(user)
    end

    describe 'GET /' do
      let!(:task_list) { create_list(:task, 2, description: 'task', user: user, list: list) }

      before do
        get '/api/v1/tasks'
      end

      it_behaves_like 'a valid api request'

      it 'has correct items' do
        expect(json['data'].length).to eq(task_list.length)
      end
    end

    describe 'POST /' do
      context 'complete params' do
        before do
          post '/api/v1/tasks', new_task
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { new_task }
        end

        it 'belongs to current_user' do
          expect(user.tasks.count).to eq(1)
        end
      end

      context 'incomplete params' do
        before do
          post 'api/v1/tasks', {}
        end

        it_behaves_like 'an invalid api request'
      end
    end

    describe 'GET /:id' do
      let(:task) { create :task, user: user, list: list }

      context 'hit' do
        before do
          get "/api/v1/tasks/#{task.id}"
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { { 'description' => task.description } }
        end
      end

      context 'miss' do
        before do
          get 'api/v1/tasks/999999'
        end

        it_behaves_like 'a resource was not found'
      end
    end

    describe 'DELETE /:id' do
      let(:task) { create :task, user: user, list: list }

      context 'hit' do
        before do
          delete "api/v1/tasks/#{task.id}"
        end

        it_behaves_like 'a valid api request'
        it_behaves_like 'a correct payload' do
          let(:payload) { { 'description' => task.description } }
        end

        it 'deletes successfully' do
          expect(user.tasks.count).to eq(0)
        end
      end

      context 'miss' do
        before do
          delete 'api/v1/tasks/99999'
        end

        it_behaves_like 'a resource was not found'
      end
    end
  end

  it_behaves_like 'an unauthenticated endpoint', '/api/v1/tasks'
end
