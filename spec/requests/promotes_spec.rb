require 'rails_helper'

RSpec.describe "Promotes", type: :request do
  before(:all) do
    @promotes = create_list(:promote, 5)
    @advertising = create(:user, role: :advertising)
    @manager = create(:user, role: :manager)
    @master = create(:user, role: :master)
  end

  describe 'GET /promotes' do
    it 'return 200' do
      get promotes_path, headers: auth_headers(@advertising)
      expect(response).to have_http_status(:ok)
      expect(response).to match_json_schema('promotes/list')
    end

    describe 'Проверка ролей' do
      it 'Доступ с правами менеджера' do
        get promotes_path, headers: auth_headers(@manager)
        expect(response).to have_http_status(:ok)
      end

      it 'Ошибка доступа с правами мастера' do
        get promotes_path, headers: auth_headers(@master)
        expect(response).to have_http_status(:forbidden)
      end

      it 'Ошибка доступа без прав' do
        get promotes_path
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /promotes/:id' do
    it 'return 200' do
      get promote_path(@promotes.first.id), headers: auth_headers(@advertising)
      expect(response).to have_http_status(:ok)
      expect(response).to match_json_schema('promotes/id')
    end

    describe 'Проверка ролей' do
      it 'Доступ с правами менеджера' do
        get promote_path(@promotes.first.id), headers: auth_headers(@manager)
        expect(response).to have_http_status(:ok)
      end

      it 'Ошибка доступа с правами мастера' do
        get promote_path(@promotes.first.id), headers: auth_headers(@master)
        expect(response).to have_http_status(:forbidden)
      end

      it 'Ошибка доступа без прав' do
        get promote_path(@promotes.first.id)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /promotes' do
    it 'return 201' do
      post promotes_path, params: attributes_for(:promote), headers: auth_headers(@advertising)
      expect(response).to have_http_status(:created)
      expect(response).to match_json_schema('promotes/id')
    end

    describe 'Проверка ролей' do
      it 'Доступ с правами менеджера' do
        post promotes_path, params: attributes_for(:promote), headers: auth_headers(@manager)
        expect(response).to have_http_status(:created)
      end

      it 'Ошибка доступа с правами мастера' do
        post promotes_path, params: attributes_for(:promote), headers: auth_headers(@master)
        expect(response).to have_http_status(:forbidden)
      end

      it 'Ошибка доступа без прав' do
        post promotes_path, params: attributes_for(:promote)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /promotes' do
    it 'return 204' do
      delete promote_path(@promotes.first.id), headers: auth_headers(@advertising)
      expect(response).to have_http_status(:no_content)
    end

    describe 'Проверка ролей' do
      it 'Доступ с правами менеджера' do
        delete promote_path(@promotes.first.id), headers: auth_headers(@manager)
        expect(response).to have_http_status(:no_content)
      end

      it 'Ошибка доступа с правами мастера' do
        delete promote_path(@promotes.first.id), headers: auth_headers(@master)
        expect(response).to have_http_status(:forbidden)
      end

      it 'Ошибка доступа без прав' do
        delete promote_path(@promotes.first.id)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
