# frozen_string_literal: true

class NewsController < ApplicationController
  load_and_authorize_resource

  # GET /news
  def index
    render json: NewsSerializer.new(@news).serialized_json
  end

  # GET /news/1
  def show
    render json: NewsSerializer.new(@news, params: {current_user: current_user}).serialized_json
  end

  # POST /news
  def create
    @news = News.new(news_params)
    @news.user = current_user

    if @news.save
      render json: NewsSerializer.new(@news, params: {current_user: current_user}).serialized_json, status: :created, location: @news
    else
      render json: @news.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /news/1
  def update
    if @news.update(news_params)
      render json: NewsSerializer.new(@news, params: {current_user: current_user}).serialized_json
    else
      render json: @news.errors, status: :unprocessable_entity
    end
  end

  # DELETE /news/1
  def destroy
    @news.destroy
  end

  private

  # Only allow a trusted parameter "white list" through.
  def news_params
    params.permit(:title, :description, :published_at)
  end
end
