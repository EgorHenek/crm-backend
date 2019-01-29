# frozen_string_literal: true

class PromotesController < ApplicationController
  load_and_authorize_resource

  # GET /promotes
  def index
    render json: PromoteSerializer.new(@promotes).serialized_json
  end

  # GET /promotes/1
  def show
    render json: PromoteSerializer.new(@promote).serialized_json
  end

  # POST /promotes
  def create
    @promote = Promote.new(promote_params)

    if @promote.save
      render json: PromoteSerializer.new(@promote).serialized_json, status: :created, location: @promote
    else
      render json: @promote.errors, status: :unprocessable_entity
    end
  end

  # DELETE /promotes/1
  def destroy
    @promote.destroy
  end

  # POST /promotes/1/start
  def start
    @promote = Promote.find(params[:promote_id])

    if @promote.started_at.blank?
      PromoteJob.perform_later(@promote)
      @promote.started_at = Time.now
      render status: :no_content
    else
      render status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def promote_params
    params.permit(:title, :text)
  end
end
