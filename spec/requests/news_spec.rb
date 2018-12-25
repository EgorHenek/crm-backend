require 'rails_helper'

RSpec.describe "News", type: :request do
  before(:all) do
    @news = create(:news)
    @un_published_news = create(:news, published_at: nil)
    @user = create(:user)
  end


  it 'GET /news' do
    get news_index_path
    expect(response).to have_http_status(200)
    expect(response).to match_json_schema('news/list')
  end

  describe 'GET /news/:id' do
    it 'return 200' do
      get news_path(@news.slug)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('news/id')
    end

    it 'return 200 with created_at and updated_at' do
      get news_path(@news.slug), headers: auth_headers(@user)
      expect(response).to have_http_status(200)
      expect(response).to match_json_schema('news/id_with_created_at')
    end

    describe 'Валидация' do
      it 'Попытка получить доступ к неопубликованой новости' do
        get news_path(@un_published_news.slug)
        expect(response).to have_http_status(:forbidden)
      end
      it 'Попытка получить доступ к неопубликованой новости с правами' do
        get news_path(@un_published_news.slug), headers: auth_headers(@user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST /news' do
    it 'return created' do
      post news_index_path, params: attributes_for(:news), headers: auth_headers(@user)
      expect(response).to have_http_status(:created)
      expect(response).to match_json_schema('news/id_with_created_at')
    end

    describe 'Валидация' do
      it 'Попытка создания без прав' do
        post news_index_path, params: attributes_for(:news)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /news/:id' do
    it 'return no_content' do
      delete news_path(@news.slug), headers: auth_headers(@user)
      expect(response).to have_http_status(:no_content)
    end

    describe 'Валидация' do
      it 'Попытка удаления без прав' do
        delete news_path(@news.slug)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /news/:id' do
    it 'return 200' do
      put news_path(@news.slug), headers: auth_headers(@user), params: {title: 'new title'}
      expect(response).to have_http_status(:ok)
      expect(response).to match_json_schema('news/id_with_created_at')
    end

    describe 'Валидация' do
      it 'Попытка изменения без прав' do
        put news_path(@news.slug), params: {title: 'new title'}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
