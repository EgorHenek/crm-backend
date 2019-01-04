# frozen_string_literal: true

class ClientsController < ApplicationController
  load_and_authorize_resource

  # GET /clients
  def index
    render json: ClientSerializer.new(@clients).serialized_json
  end

  # GET /clients/1
  def show
    render json: ClientSerializer.new(@client).serialized_json
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      ClientMailer.with(client: @client).welcome_email.deliver_later if @client.email.present?
      render json: ClientSerializer.new(@client).serialized_json, status: :created, location: @client
    else
      render json: @client.errors.full_messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render json: ClientSerializer.new(@client).serialized_json
    else
      render json: @client.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
  end

  private

  # Only allow a trusted parameter "white list" through.
  def client_params
    params.permit(:name, :address, :email, :phone, :promotion, :first_contact)
  end
end
