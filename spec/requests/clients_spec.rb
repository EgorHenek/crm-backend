# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  before(:all) do
    @user = create(:user)
    @manager = create(:user, role: 'manager')
    @clients = create_list(:client, 7)
    @advertising = create(:user, role: 'advertising')
  end

  describe 'GET /clients' do
    it 'return 200' do
      get clients_path, headers: auth_headers(@user)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('clients/list')
    end

    describe 'Проверка прав' do
      it 'Без авторизации' do
        get clients_path
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'GET /clients/:id' do
    it 'return 200' do
      get client_path(@clients.first), headers: auth_headers(@user)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('clients/id')
    end

    describe 'Проверка прав' do
      it 'Без авторизации' do
        get client_path(@clients.first)
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST /clients' do
    it 'return 200' do
      post clients_path, headers: auth_headers(@manager), params: attributes_for(:client)
      expect(response).to have_http_status(201)
      expect(response).to match_json_schema('clients/id')
    end

    describe 'Проверка прав' do
      it 'Без авторизации' do
        post clients_path, params: attributes_for(:client)
        expect(response).to have_http_status(201)
        expect(response).to match_json_schema('clients/id')
      end
    end

    describe 'Валидация' do
      it 'Только email' do
        post clients_path, headers: auth_headers(@manager), params: attributes_for(:client, phone: '')
        expect(response).to have_http_status(201)
        expect(response).to match_json_schema('clients/id')
      end

      it 'Уже существующий email' do
        post clients_path, params: { name: @clients.first.name, emails: @clients.first.email }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'Уже существующий телефон' do
        post clients_path, params: { name: @clients.first.name, emails: @clients.first.phone }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'Не введён телефон или email' do
        post clients_path, params: { name: @clients.first.name }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /clients' do
    it 'return 200' do
      delete client_path(@clients.first), headers: auth_headers(@manager)
      expect(response).to have_http_status(:no_content)
    end

    describe 'Проверка прав' do
      it 'Без авторизации' do
        delete client_path(@clients.first)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /clients' do
    it 'return 200' do
      put client_path(@clients.first), headers: auth_headers(@manager), params: { address: 'New address' }
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('clients/id')
    end

    describe 'Проверка прав' do
      it 'Без авторизации' do
        put client_path(@clients.first), params: { address: 'New address' }
        expect(response).to have_http_status(:forbidden)
      end

      it 'С правами advertising' do
        put client_path(@clients.first), headers: auth_headers(@advertising), params: { address: 'New address' }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
