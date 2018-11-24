# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  before(:all) do
    @creator = create(:user)
    @performer = create(:user)
    @subcontactor = create(:user)
    @user = create(:user, role: '')
    @task = create(:task, creator: @creator, performer: @performer)
  end

  describe 'GET /tasks' do
    it 'return 200' do
      get tasks_path, headers: auth_headers(@creator)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('tasks/list')
    end
  end

  describe 'GET /tasks/id' do
    it 'return 200 creator' do
      get task_path(@task), headers: auth_headers(@creator)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('tasks/id')
    end
    it 'return 200 performer' do
      get task_path(@task), headers: auth_headers(@performer)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('tasks/id')
    end
    it 'Ошибка доступа' do
      get task_path(@task), headers: auth_headers(@user)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /tasks' do
    it 'return 200' do
      post tasks_path, headers: auth_headers(@creator), params: { task: attributes_for(:task), performer: @performer.id }
      expect(response).to have_http_status(201)
      expect(response).to match_json_schema('tasks/id')
    end

    it 'Ошибка доступа' do
      post tasks_path, headers: auth_headers(@user), params: { task: attributes_for(:task), performer: @performer.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /tasks/id' do
    it 'return 200' do
      delete task_path(@task), headers: auth_headers(@creator)
      expect(response).to have_http_status(:no_content)
    end

    describe 'Ошибка доступа' do
      it 'User' do
        delete task_path(@task), headers: auth_headers(@user)
        expect(response).to have_http_status(:forbidden)
      end
      it 'Не создатель' do
        delete task_path(@task), headers: auth_headers(@performer)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /tasks/id' do
    it 'return 200' do
      put task_path(@task), headers: auth_headers(@creator), params: { task: { description: 'Test', notify: Time.now, start_time: Time.now, end_time: Time.now + 5.days, color: 'red' } }
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('tasks/id')
    end
    it 'Ошибка дсоутпа' do
      put task_path(@task), headers: auth_headers(@user), params: { task: { description: 'Test', notify: Time.now, start_time: Time.now, end_time: Time.now + 5.days, color: 'red' } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'Subcontactors' do
    describe 'POST /tasks/:id/subcontactors' do
      it 'return 200' do
        post subcontactors_task_path(@task), headers: auth_headers(@creator), params: { subcontactor: @subcontactor.id }
        expect(response).to have_http_status(200)
        expect(response).to match_json_schema('tasks/id')
      end
      it 'Ошибка доступа' do
        post subcontactors_task_path(@task), headers: auth_headers(@performer), params: { subcontactor: @subcontactor.id }
        expect(response).to have_http_status(:forbidden)
      end
      it 'Ошибка добавления пользователя не имеющего прав' do
        post subcontactors_task_path(@task), headers: auth_headers(@creator), params: { subcontactor: @user.id }
        expect(response).not_to have_http_status(:ok)
      end
    end

    describe 'DELETE /tasks/:id/subcontactors' do
      before(:all) do
        @task = create(:task, creator: @creator, performer: @performer, subcontactors: [@subcontactor])
      end
      it 'return 200' do
        delete subcontactors_task_path(@task), headers: auth_headers(@creator), params: { subcontactor: @subcontactor.id }
        expect(response).to have_http_status(:no_content)
      end
      it 'Ошибка доступа' do
        delete subcontactors_task_path(@task), headers: auth_headers(@performer), params: { subcontactor: @subcontactor.id }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
